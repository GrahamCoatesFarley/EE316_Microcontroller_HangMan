
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity top_level is
    port (
        SCL_LCD : inout std_logic;
        SDA_LCD : inout std_logic;
        SCL_SEG : inout std_logic;
        SDA_SEG : inout std_logic;
        clk         : in std_logic; --sysclock
        ips2_clk    : in std_logic; --clock from keyboard
        ips2_data   : in std_logic; --data from keyboard
        irx         : in std_logic; --In on uart rx
        ireset      : in std_logic; --external reset signal
        otx         : out std_logic --out on uart tx
    );
end top_level;


architecture Behavioral of top_level is

component seven_seg_i2c is
    Port(
         clk            :in STD_LOGIC;
         iData          :in STD_LOGIC_VECTOR(7 downto 0);
         reset          :in STD_LOGIC;
         address        :in std_logic_vector(6 downto 0);
         sda, scl       :inout std_logic  
         );
end component;

component Reset_Delay IS	
    generic(MAX: integer := 15);
    PORT (
        iCLK : IN std_logic;	
        oRESET : OUT std_logic
			);	
END component;

component ps2_keyboard_to_ascii IS
  GENERIC(
      clk_freq                  : INTEGER := 100_000_000; --system clock frequency in Hz
      ps2_debounce_counter_size : INTEGER := 9);         --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
  PORT(
      clk        : IN  STD_LOGIC;                     --system clock input
      ps2_clk    : IN  STD_LOGIC;                     --clock signal from PS2 keyboard
      ps2_data   : IN  STD_LOGIC;                     --data signal from PS2 keyboard
      ascii_new  : OUT STD_LOGIC;                     --output flag indicating new ASCII value
      ascii_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)); --ASCII value
END component;

component LCD_Super_USR is
    Port ( 
       SCL : inout STD_LOGIC;
       SDA : inout STD_LOGIC;
       address : in STD_LOGIC_VECTOR (6 downto 0);
       reset : in std_logic;
       clk      : in std_logic;
       rx_empty : in std_logic;
       rx_unload : in std_logic;
       UART_Data : in std_logic_vector(7 downto 0)
       );
end component;

component uart_user_logic is
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
end component;

    signal ps2_data : std_logic := '1';
    signal ascii_ready, reset  : std_logic := '0';
    signal uart_data, uart_read    : std_logic_vector(7 downto 0);
	signal reset_onstart : std_logic := '0';
    
    signal scl, sda      : std_logic;
    signal rx_empty, rx_unload, tx_empty  : std_logic;
    signal uart_temp_data : std_logic_vector(6 downto 0);
   -- signal lcd_address   : std_logic_vector(3 downto 0);

begin
uart_data <= '0'&uart_temp_data;

ps2_keyboard_to_ascii_0 : ps2_keyboard_to_ascii
  GENERIC map(
      clk_freq                  => 100_000_000, --system clock frequency in Hz
      ps2_debounce_counter_size => 9)          --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)   - 9 for 100 mhz
  PORT map(
      clk        => clk,          --system clock input
      ps2_clk    => ips2_clk,     --clock signal from PS2 keyboard
      ps2_data   => ips2_data,     --data signal from PS2 keyboard
      ascii_new  => ascii_ready,  --output flag indicating new ASCII value
      ascii_code => uart_temp_data);   --ASCII value

LCD_Super_USR_0 : LCD_Super_USR
    Port map( 
           SCL      => SCL_LCD,
           SDA      => SDA_LCD,
		   address  => "0100111",
		   reset    => reset,
		   clk      => clk,
		   rx_empty => rx_empty,
		   rx_unload => rx_unload,
           UART_Data => uart_read
           --top_row : out std_logic_vector(127 downto 0);
           --bottom_row : out std_logic_vector(127 downto 0)
		   );

seven_seg: seven_seg_i2c
    Port map(
         clk        => clk,
         iData      => uart_read,
         reset      => reset,
         address    => "1110001",
         sda        => SDA_SEG,
		 scl        => SCL_SEG
         );


uart_user_logic_0 : uart_user_logic
generic map( baud_rate  => 115200, clock => 100_000_000)
    port map(
        clk          => clk,
        new_send     => ascii_ready,
        reset_in     => reset,
        tx_data      => uart_data,  -- data you send in 
        tx_out       => otx,        -- to the other system  
        tx_empty     => tx_empty,   -- went through all data - can accept new data
        rx_data      => uart_read,  -- data that goes out of the module
        rx_in        => irx,        -- data coming from other system
        rx_empty_out => rx_empty,
        rx_uload_out => rx_unload
    );

onstart_reset: Reset_Delay
    generic map(MAX=> 150_000)
    PORT map(
        iCLK => clk,
        oRESET => reset_onstart
			);	

    reset <= ireset or reset_onstart;
-- yellow = ground

end Behavioral;
