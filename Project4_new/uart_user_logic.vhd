library ieee;
     use ieee.std_logic_1164.all;
     use ieee.std_logic_unsigned.all;
	  use IEEE.NUMERIC_STD.ALL;
 
 entity uart_user_logic is
    generic(CONSTANT baud_rate : integer := 115200; CONSTANT clock : integer := 100000000);
     port (
		 clk : in std_logic;
		 new_send     :in std_logic;
         reset_in       :in  std_logic;
         tx_data     :in  std_logic_vector (7 downto 0);   -- data you send in 
         tx_out      :out std_logic;   -- to the other system  
         tx_empty    :out std_logic;    -- went through all data - can accept new data
         rx_data     :out std_logic_vector (7 downto 0);   -- data that goes out of the module
         rx_in       :in  std_logic;    -- data coming from other system
         rx_empty_out : out std_logic;
		 rx_uload_out : out std_logic
     );
 end uart_user_logic;
 
 architecture behavior of uart_user_logic is
 
	component uart is
     port (
         reset       :in  std_logic;   -- reset from user or system
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
	end component;
    
  component  clk_enabler is
	GENERIC (
		CONSTANT cnt_max : integer := 49999999);      --  1.0 Hz 
	port(	
		clock:		in std_logic;	 
		reset_n:       in std_logic;
		clk_en: 		out std_logic
	);
	end component;
 signal tx_data_sig     :  std_logic_vector (7 downto 0);   -- data you send in from upper level
 signal reset_sig : std_logic := '0';
 signal reset : std_logic;
 signal reset_cnt : integer range 0 to 100 := 0;
 signal reset_n : std_logic;
 signal buad_rate_send : std_logic;
  signal buad_rate_recieve : std_logic;
 signal ld_tx_data : std_logic;
 signal tx_empty_sig : std_logic;
 signal uld_rx_data : std_logic;
 signal rx_empty_sig : std_logic;
 signal send_baud : integer range  0 to 900:= 0;
 signal recieve_baud : integer range  0 to 900:= 0;

 
 begin
-- tx_data_sig <= '0'&tx_data(6 downto 0);
send_baud <= clock / baud_rate;
recieve_baud <= (clock / (16 * baud_rate));

 rx_uload_out <= uld_rx_data;
 reset <= reset_sig or reset_in;
 reset_n <= not reset;
 tx_empty <= tx_empty_sig;
 rx_empty_out <= rx_empty_sig;
 
 
 uart_manager : uart 
     port map(
         reset       => reset,
         txclk       => buad_rate_send,
         ld_tx_data  => ld_tx_data,
         tx_data     => tx_data,
         tx_enable   => '1',
         tx_out      => tx_out,
         tx_empty    => tx_empty_sig,
         rxclk       => buad_rate_recieve,
         uld_rx_data => uld_rx_data,
         rx_data     => rx_data,
         rx_enable   => '1',
         rx_in       => rx_in,
         rx_empty    => rx_empty_sig
     );
 
 
 BUAD_RATE_clk_Send : clk_enabler    -- 16 times more than recieve
	GENERIC map(
		 cnt_max => integer(clock / baud_rate))      --  1.0 Hz 
	port map(	
		clock => clk, 
		reset_n => reset_n,
		clk_en => buad_rate_send
	);
 
 BUAD_RATE_clk_recieve : clk_enabler
	GENERIC map(
		 cnt_max => integer(clock / (16 * baud_rate)))      -- baud rate of 115200 for 100mhz recieving 
	port map(	
		clock => clk, 
		reset_n => reset_n,
		clk_en => buad_rate_recieve
	);
 
 reset_prcs : process(clk, reset)
 begin
	if(rising_edge(clk)) then
		if(reset_cnt /= 0) then
			reset_sig <= '1';
			reset_cnt <= reset_cnt -1;
		else
			reset_sig <= '0';
		end if;
	end if;
 
 end process;
 
 
 
 Send_PROCESS: process(reset, clk) 
 begin
 
	if(rising_edge(clk)) then
		if(reset = '0') then
			if(tx_empty_sig = '1') then
			     if(new_send = '1') then
			         ld_tx_data <= '1';
			     end if;
			
			else
				ld_tx_data <= '0';
			
			end if;	
		end if;
	end if;
 end process;
 
 
 
 Recieve_PROCESS: process(reset, clk) 
 begin
	if(rising_edge(clk)) then
		if(reset = '0') then
			if(rx_empty_sig = '0') then
				uld_rx_data <= '1';
			
			else
				uld_rx_data <= '0';
			
			end if;
		end if;
	end if;
 end process;
 
 
 end behavior;