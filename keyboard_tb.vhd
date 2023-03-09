----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2023 03:05:57 PM
-- Design Name: 
-- Module Name: keyboard_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity keyboard_tb is
--  Port ( );
end keyboard_tb;

architecture Behavioral of keyboard_tb is

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
end component;

	signal clk, ps2_clk, ps2_data  : std_logic := '1';
	signal ascii_new	           : std_logic;
	signal ascii_code              : std_logic_vector(6 downto 0);
	signal data                    : std_logic_vector(7 downto 0);

begin

DUT : ps2_keyboard_to_ascii
  GENERIC map(
      clk_freq                  => 50_000_000, --system clock frequency in Hz
      ps2_debounce_counter_size => 8)   	     --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
  PORT map(
      clk        => clk,                     --system clock input
      ps2_clk    => ps2_clk,                     --clock signal from PS2 keyboard
      ps2_data   => ps2_data,                    --data signal from PS2 keyboard
      ascii_new  => ascii_new,                     --output flag indicating new ASCII value
      ascii_code => ascii_code--ASCII value
	  );
	--Start this
	process 
	begin
	   while true loop
	       clk <= not clk;
	       wait for 10 ns;
	   end loop;
	end process;
	process 
	begin
	   while true loop
	       ps2_clk <= not ps2_clk;
	       wait for 30 us;
	   end loop;
	end process;
	
	process
	begin
	
	   ps2_data <= '0';
	   wait for 55 us;
	   data <= x"1c"; --'a'
	   for i in 0 to 7 loop
	       ps2_data <= '1';
	       wait for 55 us;
	       ps2_data <= '0';
	       wait for 55 us;
	       ps2_data <= data(i);
	       wait for 55 us;
	   end loop;
	   ps2_data <= not (ps2_data xor '1');
	   wait for 55 us;
	   ps2_data <= '1';
	
	end process;
end Behavioral;
