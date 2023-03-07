library ieee;
     use ieee.std_logic_1164.all;
     use ieee.std_logic_unsigned.all;
 


entity uart_tb is
--  Port ( );
end uart_tb;

architecture Behavioral of uart_tb is

 component uart_user_logic is
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
 end component;
 
signal clk :  std_logic:='0';
signal new_send     : std_logic;
signal reset_in       :  std_logic;
signal tx_data     :  std_logic_vector (7 downto 0);   -- data you send in 
signal tx_out      : std_logic;   -- to the other system  
signal tx_empty    : std_logic;    -- went through all data - can accept new data
signal rx_data     : std_logic_vector (7 downto 0);   -- data that goes out of the module
signal rx_in       :  std_logic;    -- data coming from other system
signal rx_empty_out :  std_logic;
signal rx_uload_out :  std_logic;
 
begin

DUT: uart_user_logic
 port map(
         clk => clk,
		 new_send => new_send,
         reset_in      => reset_in,
         tx_data    => tx_data,
         tx_out     => tx_out,
         tx_empty    => tx_empty,
         rx_data  => rx_data,
         rx_in      => rx_in,
         rx_empty_out    => rx_empty_out,
		 rx_uload_out  => rx_uload_out
     );
     
     clk <= not clk after 5 ns;
     
     process
     begin
     reset_in <= '1';
     wait for 1 ms;
     reset_in <= '0';
     tx_data <= "11100100";
     
     rx_in <= '0';   -- first bit recieving
     wait for 8680 ns;
     
     rx_in <= '1';
     wait for 8680 ns;
     
     rx_in <= '0';
     wait for 8680 ns;
     
     rx_in <= '1';
     wait for 8680 ns;
     
     rx_in <= '1';
     wait for 8680 ns;
     
     rx_in <= '0';
     wait for 8680 ns;
     
     rx_in <= '0';
     wait for 8680 ns;
     
     rx_in <= '1';
     wait for 8680 ns;
     
     rx_in <= '0';
     wait for 8680 ns;
     
     rx_in <= '1';
     wait for 8680 ns;
     
     
     wait;
     end process;
     
     


end Behavioral;
