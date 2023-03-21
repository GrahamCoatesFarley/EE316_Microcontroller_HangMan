library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity LCD_i2c is
    Port ( 
           SCL : inout STD_LOGIC;
           SDA : inout STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in std_logic;
           address : in STD_LOGIC_VECTOR (6 downto 0);
           top_row : in std_logic_vector(127 downto 0);
           bottom_row : in std_logic_vector(127 downto 0));
end LCD_i2c;



architecture Behavioral of LCD_i2c is

COMPONENT i2c_master is
	GENERIC (
            input_clk : INTEGER := 50_000_000;
            bus_clk   : INTEGER := 400_000);  -- change to slower speed 
		port(    
            clk       : IN     STD_LOGIC;                    
            reset_n   : IN     STD_LOGIC;                    
            ena       : IN     STD_LOGIC;                    
            addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); 
            rw        : IN     STD_LOGIC;                    
            data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); 
            busy      : OUT    STD_LOGIC;                    
            data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); 
            ack_error : BUFFER STD_LOGIC;                    
            sda       : INOUT  STD_LOGIC;                    
            scl       : INOUT  STD_LOGIC);                   
end COMPONENT;

--component clk_enabler is
--	GENERIC (
--		CONSTANT cnt_max : integer := 49999999);      --  1.0 Hz 
--	port(	
--		clock:		in std_logic;	 
--		reset_n:       in std_logic;
--		clk_en: 		out std_logic
--	);
--end component;


TYPE state_type IS(start, ready, data_valid, busy_high, repeat); --needed states
signal state       : state_type:=start;                   
signal reset_n     : STD_LOGIC;                   
signal ena         : STD_LOGIC;                    
signal data_wr     : STD_LOGIC_VECTOR(7 DOWNTO 0);  
signal data_rd     : std_logic_vector(7 downto 0);
signal busy        : STD_LOGIC;                    
--signal byteSel     : integer range 0 to 30:=0;
signal rw          : std_logic:='0';
signal addr_master : std_logic_vector(6 downto 0);
signal addr        : std_logic_vector(6 downto 0);
--signal idata       : STD_LOGIC_VECTOR(15 downto 0);
signal data_wr_m : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal clk_en : std_LOGIC:='0'; 

signal control_bits : std_logic_vector(7 downto 0);
signal mode_before : std_logic_vector(2 downto 0);
signal flag : std_LOGIC:='0';
signal ack_error : std_LOGIC;

signal to_write : std_logic_vector(7 downto 0);

signal data : std_logic_vector(8 downto 0);
signal count : integer range 0 to 8:=0; 
signal byte_select : integer range 0 to 40:=0;
--signal clk_en : std_logic;

signal clk_cnt : integer range 0 to 500000:=0;
signal setup_flag: std_logic:='0';

begin

reset_n <= not reset;

--Inst_clken: clk_enabler 
--	GENERIC map(
--		cnt_max => 99999)      --  1.0 Hz 
--	port map(	
--		clock => clk,	 
--		reset_n => '1',
--		clk_en  => clk_en
--	);


Inst_i2c_master_lcd: i2c_master
	GENERIC map(input_clk => 100_000_000,
                bus_clk   => 400_000)
	port map(
		    clk       => clk,               
            reset_n   => reset_n,              
            ena       => ena,         
            addr      => addr_master,
            rw        => rw,      
            data_wr   => data_wr_m,
            busy      => busy,           
            data_rd   => open,          -- handled in master?? 
            ack_error => open,          -- handled in master??                  
            sda       => sda,                 
            scl       => scl
		); 

LUT: process(clk, byte_select)
begin
    case byte_select is
        when 0 => data <= '0'&X"28";
        when 1 => data <= '0'&X"28";
        when 2 => data <= '0'&X"28";
        when 3 => data <= '0'&X"01";
        when 4 => data <= '0'&X"0C";
        when 5 => data <= '0'&X"06";
        when 6 => data <= '0'&X"80";
        when 7 => data <= '1'&top_row(127 downto 120);
        when 8 => data <= '1'&top_row(119 downto 112);
        when 9 => data <= '1'&top_row(111 downto 104);
        when 10 => data <= '1'&top_row(103 downto 96);
        when 11 => data <= '1'&top_row(95 downto 88);
        when 12 => data <= '1'&top_row(87 downto 80);
        when 13 => data <= '1'&top_row(79 downto 72);
        when 14 => data <= '1'&top_row(71 downto 64);
        when 15 => data <= '1'&top_row(63 downto 56);
        when 16 => data <= '1'&top_row(55 downto 48);
        when 17 => data <= '1'&top_row(47 downto 40);
        when 18 => data <= '1'&top_row(39 downto 32);
        when 19 => data <= '1'&top_row(31 downto 24);
        when 20 => data <= '1'&top_row(23 downto 16);
        when 21 => data <= '1'&top_row(15 downto 8);
        when 22 => data <= '1'&top_row(7 downto 0);
        when 23 => data <= '0'&X"C0";
        when 24 => data <= '1'&bottom_row(127 downto 120);
        when 25 => data <= '1'&bottom_row(119 downto 112);
        when 26 => data <= '1'&bottom_row(111 downto 104);
        when 27 => data <= '1'&bottom_row(103 downto 96);
        when 28 => data <= '1'&bottom_row(95 downto 88);
        when 29 => data <= '1'&bottom_row(87 downto 80);
        when 30 => data <= '1'&bottom_row(79 downto 72);
        when 31 => data <= '1'&bottom_row(71 downto 64);
        when 32 => data <= '1'&bottom_row(63 downto 56);
        when 33 => data <= '1'&bottom_row(55 downto 48);
        when 34 => data <= '1'&bottom_row(47 downto 40);
        when 35 => data <= '1'&bottom_row(39 downto 32);
        when 36 => data <= '1'&bottom_row(31 downto 24);
        when 37 => data <= '1'&bottom_row(23 downto 16);
        when 38 => data <= '1'&bottom_row(15 downto 8);
        when 39 => data <= '1'&bottom_row(7 downto 0);
        when 40 => data <= '0'&X"80";   -- usually 40
        when others => data <= '1'&X"00";
    end case;
end process;

CURRENTBIT: process(clk, count)
begin
    case count is
        when 0 => to_write <= data(7 downto 4)&"100"&data(8);
        when 1 => to_write <= data(7 downto 4)&"110"&data(8);
        when 2 => to_write <= data(7 downto 4)&"100"&data(8);
        
        when 3 => to_write <= data(7 downto 4)&"100"&data(8);
        when 4 => to_write <= data(7 downto 4)&"110"&data(8);
        when 5 => to_write <= data(7 downto 4)&"100"&data(8);
        
        when 6 => to_write <= data(3 downto 0)&"100"&data(8);
        when 7 => to_write <= data(3 downto 0)&"110"&data(8);
        when 8 => to_write <= data(3 downto 0)&"100"&data(8);
        when others => to_write <= X"00";
    end case;
end process;
    


process(clk)
begin
    
    if(rising_edge(clk)) then
        addr <= address;
        clk_cnt <= clk_cnt +1;
--        if(count >= 5) then
--            count <= 0;
--            byte_select <= byte_select +1;   -- incrementign byte select after count goes through entire data piece
--        end if;
        
      
        
            case state is 
                when start =>
                    if reset = '1' then	
								if(setup_flag = '1') then
									count <= 3;
							   end if;
                        byte_select <= 0;	
                        ena 	<= '0'; 
                        state   <= start; 
                    else
                         if(busy = '0') then
                            ena <= '0';  -- enable for communication with master
                            rw <= '0';   -- write
                            data_wr_m <= to_write;   --data to be written 
                            addr_master <= addr; 
                            state   <= ready;  -- ready to write 
									setup_flag <= '1'; 
                        end if;         
                    end if;
    
                when ready =>		
                    if busy = '0' then                      -- state to signal ready for transaction
                        ena     <= '1';
                        state   <= data_valid;
                    end if;
    
                when data_valid =>                              --state for conducting this transaction
                    if busy = '1' then  
                        ena     <= '0';
                        state   <= busy_high;
                    end if;
    
                when busy_high => 
                    if busy = '0' then                -- busy just went low 
                        state <= repeat;
                    end if;		   
                      
                when repeat =>
                  if(clk_cnt >= 499999) then   -- change for 100 mhz
                    state <= start; 
                    clk_cnt <= 0;
                    if(count >= 8) then
                        count <= 3;
                        if(byte_select >= 22) then
                            byte_select <= 6;   -- goinging to where the data is staritng   
                        else
                            byte_select <= byte_select +1;   -- incrementign byte select after count goes through entire data piece 
                        end if;
                    else
                        count <= count +1;
                    end if;
                 end if;
            when others => null;
            end case;   
     
    end if;
    
  end process;
end Behavioral;  
    
    -- LUT with modes
    -- LUT with words/commands as 9 bit items

-- count in i2c process 0 to 5 for each number of the 8-bit HEX ascii value with commands concatonated where they are supposed to be
-- this is in a seperate case statement dependent on clock and count


