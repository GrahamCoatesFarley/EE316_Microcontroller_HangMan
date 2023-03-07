library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity LCD_Super_USR is
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
end LCD_Super_USR;


architecture arch of LCD_Super_USR is

component LCD_i2c is
    Port ( 
           SCL : inout STD_LOGIC;
           SDA : inout STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in std_logic;
           address : in STD_LOGIC_VECTOR (6 downto 0);
           top_row : in std_logic_vector(127 downto 0);
           bottom_row : in std_logic_vector(127 downto 0)
           );
end component;


signal row : std_logic_vector(127 downto 0):="0000000000000000";
TYPE state_type IS(unload, reset_empty, data); --needed states 
signal state : state_type:=unload;
signal top_row : std_logic_vector(127 downto 0):= X"00000000000000000000000000000000";
signal bottom_row : std_logic_vector(127 downto 0):= X"20202020202020202020202020202020";

begin

INST_LCD : LCD_i2c
Port map( 
           SCL => SCL,
           SDA => SDA,
           clk => clk,
           reset => reset,
           address => address,
           top_row => top_row,
           bottom_row => bottom_row
           );


top_row <= row;

process(clk)
begin
if(rising_edge(clk)) then
    
    if(UART_Data(7) = '0') then
		case state is
			when unload =>
				if(rx_unload = '1') then
					state <= reset_empty;
				end if;
			
			when reset_empty  =>
				if(rx_empty = '1') then
					state <= data;
				end if;
				
			when data =>
				row <= (row & '0' & UART_Data(6 downto 0));   -- sliding bits to the left 
				state <= unload;
        end case;
    end if;
end if;

end process;

end architecture;


