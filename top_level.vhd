----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 12:51:01 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    port (
        clk         : in std_logic; --sysclock
        ips2_clk    : in std_logic; --clock from keyboard
        ips2_data   : in std_logic; --data from keyboard
        irx         : in std_logic; --In on uart rx
        ireset      : in std_logic; --external reset signal
        otx         : out std_logic --out on uart tx
    );
end top_level;

architecture Behavioral of top_level is

component ps2_keyboard_to_ascii IS
  GENERIC(
      clk_freq                  : INTEGER := 50_000_000; --system clock frequency in Hz
      ps2_debounce_counter_size : INTEGER := 8);         --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
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
       --top_row : out std_logic_vector(127 downto 0);
       --bottom_row : out std_logic_vector(127 downto 0)
       );
end component;

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

    signal ps2_data : std_logic := '1';
    signal ascii_ready, reset  : std_logic := '0';
    signal uart_data, uart_read    : std_logic_vector(7 downto 0);
    
    signal scl, sda      : std_logic;
    signal rx_empty, rx_unload, tx_empty  : std_logic;
    signal lcd_address   : std_logic_vector(3 downto 0);

begin

ps2_keyboard_to_ascii_0 : ps2_keyboard_to_ascii
  GENERIC map(
      clk_freq                  => 50_000_000, --system clock frequency in Hz
      ps2_debounce_counter_size => 8)          --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
  PORT map(
      clk        => clk,          --system clock input
      ps2_clk    => ips2_clk,     --clock signal from PS2 keyboard
      ps2_data   => ps2_data,     --data signal from PS2 keyboard
      ascii_new  => ascii_ready,  --output flag indicating new ASCII value
      ascii_code => uart_data);   --ASCII value

LCD_Super_USR_0 : LCD_Super_USR
    Port map( 
           SCL      => scl,
           SDA      => sda,
		   address  => lcd_address,
		   reset    => reset,
		   clk      => clk,
		   rx_empty => rx_empty,
		   rx_unload => rx_unload,
           UART_Data => uart_data
           --top_row : out std_logic_vector(127 downto 0);
           --bottom_row : out std_logic_vector(127 downto 0)
		   );

uart_user_logic_0 : uart_user_logic
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

    reset <= ireset;
end Behavioral;
