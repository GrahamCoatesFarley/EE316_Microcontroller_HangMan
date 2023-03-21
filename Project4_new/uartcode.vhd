

 -------------------------------------------------------
 -- Design Name : uart 
 -- File Name   : uart.vhd
 -- Function    : Simple UART
 -- Coder       : Deepak Kumar Tala (Verilog)
 -- Translator  : Alexander H Pham (VHDL)
 -------------------------------------------------------
 library ieee;
     use ieee.std_logic_1164.all;
     use ieee.std_logic_unsigned.all;
	  use IEEE.NUMERIC_STD.ALL;

 
 entity uart is
     port (
         reset       :in  std_logic;
         txclk       :in  std_logic;    -- buad rate
         ld_tx_data  :in  std_logic;   -- flag to set to load in data from upper level
         tx_data     :in  std_logic_vector (7 downto 0);   -- data you send in from upper level
         tx_enable   :in  std_logic;     -- enable to send data, set after load is high   -- might be ablet o leave hihg
         tx_out      :out std_logic;   -- to the other system  
         tx_empty    :out std_logic;    -- went through all data - can accept new data
         rxclk       :in  std_logic;   -- buad rate
         uld_rx_data :in  std_logic;    -- push data recieved into rx_data reg
         rx_data     :out std_logic_vector (7 downto 0);   -- data that goes out of the module
         rx_enable   :in  std_logic;   -- can keep high 
         rx_in       :in  std_logic;    -- data coming from other system
         rx_empty    :out std_logic    --  busy flag     enable for lcd to tell when to grab data 
     );
 end entity;
 
 
 architecture rtl of uart is
    -- Internal Variables
     signal tx_reg         :std_logic_vector (7 downto 0);
     signal tx_over_run    :std_logic;
     signal tx_cnt         :std_logic_vector (3 downto 0);
     signal rx_reg         :std_logic_vector (7 downto 0);
     signal rx_sample_cnt  :std_logic_vector (3 downto 0);
     signal rx_cnt         :std_logic_vector (3 downto 0);
     signal rx_frame_err   :std_logic;
     signal rx_over_run    :std_logic;
     signal rx_d1          :std_logic;
     signal rx_d2          :std_logic;
     signal rx_busy        :std_logic;
     signal rx_is_empty    :std_logic;
     signal tx_is_empty    :std_logic;
 begin
    -- UART RX Logic
     process (rxclk, reset) begin
         if (reset = '1') then
             rx_reg        <= (others=>'0');
             rx_data       <= (others=>'0');
             rx_sample_cnt <= (others=>'0');
             rx_cnt        <= (others=>'0');
             rx_frame_err  <= '0';
             rx_over_run   <= '0';
             rx_is_empty   <= '1';
             rx_d1         <= '1';
             rx_d2         <= '1';
             rx_busy       <= '0';
         elsif (rising_edge(rxclk)) then
            -- Synchronize the asynch signal
             rx_d1 <= rx_in;
             rx_d2 <= rx_d1;
            -- Uload the rx data
             if (uld_rx_data = '1') then
                 rx_data  <= rx_reg;
                 rx_is_empty <= '1';
             end if;
            -- Receive data only when rx is enabled
             if (rx_enable = '1') then
                -- Check if just received start of frame
                 if (rx_busy = '0' and rx_d2 = '0') then
                     rx_busy       <= '1';
                     rx_sample_cnt <= X"1";
                     rx_cnt        <= X"0";
                 end if;
                -- Start of frame detected, Proceed with rest of data
                 if (rx_busy = '1') then
                     rx_sample_cnt <= rx_sample_cnt + 1;
                    -- Logic to sample at middle of data
                     if (rx_sample_cnt = 7) then
                         if ((rx_d2 = '1') and (rx_cnt = 0)) then
                             rx_busy <= '0';
                         else
                             rx_cnt <= rx_cnt + 1;
                            -- Start storing the rx data
                             if (rx_cnt > 0 and rx_cnt < 9) then
                                 rx_reg(conv_integer(rx_cnt) - 1) <= rx_d2;
                             end if;
                             if (rx_cnt = 9) then
                                 rx_busy <= '0';
                                -- Check if End of frame received correctly
                                 if (rx_d2 = '0') then
                                     rx_frame_err <= '1';
                                 else
                                     rx_is_empty  <= '0';
                                     rx_frame_err <= '0';
                                    -- Check if last rx data was not unloaded,
                                     if (rx_is_empty = '1') then
                                         rx_over_run  <= '0';
                                     else
                                         rx_over_run  <= '1';
                                     end if;
                                 end if;
                             end if;
                         end if;
                     end if;
                 end if;
             end if;
             if (rx_enable = '0') then
                 rx_busy <= '0';
             end if;
         end if;
     end process;
     rx_empty <= rx_is_empty;
     
    -- UART TX Logic
     process (txclk, reset) begin
         if (reset = '1') then
             tx_reg        <= (others=>'0');
             tx_is_empty   <= '1';
             tx_over_run   <= '0';
             tx_out        <= '1';
             tx_cnt        <= (others=>'0');
         elsif (rising_edge(txclk)) then
 
             if (ld_tx_data = '1') then
                 if (tx_is_empty = '0') then
                     tx_over_run <= '0';
                 else
                     tx_reg   <= tx_data;
                     tx_is_empty <= '0';
                 end if;
             end if;
             if (tx_enable = '1' and tx_is_empty = '0') then
                 tx_cnt <= tx_cnt + 1;
                 if (tx_cnt = 0) then
                     tx_out <= '0';
                 end if;
                 if (tx_cnt > 0 and tx_cnt < 9) then
                     tx_out <= tx_reg(conv_integer(tx_cnt) -1);
                 end if;
                 if (tx_cnt = 9) then
                     tx_out <= '1';
                     tx_cnt <= X"0";
                     tx_is_empty <= '1';
                 end if;
             end if;
             if (tx_enable = '0') then
                 tx_cnt <= X"0";
             end if;
         end if;
     end process;
     tx_empty <= tx_is_empty;
 
 end architecture;