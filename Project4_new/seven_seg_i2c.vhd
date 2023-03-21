library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_i2c is
    Port(
         clk            :in STD_LOGIC;
         iData          :in STD_LOGIC_VECTOR(7 downto 0);
         reset          :in STD_LOGIC;
         address        :in std_logic_vector(6 downto 0);
         sda, scl       :inout std_logic  
         );
end seven_seg_i2c;

architecture user_logic of seven_seg_i2c is

TYPE state_type IS(start, ready, data_valid, busy_high, repeat); --needed states
signal state       : state_type:=start;                   
signal reset_n     : STD_LOGIC:='1';                   
signal ena         : STD_LOGIC;                    
signal data_wr     : STD_LOGIC_VECTOR(7 DOWNTO 0);  
signal busy        : STD_LOGIC;                    
signal byteSel     : integer range 0 to 30:=0;
signal rw          : std_logic:='0';
signal addr_master : std_logic_vector(6 downto 0);
signal addr        : std_logic_vector(6 downto 0);
signal data_sig       : STD_LOGIC_VECTOR(15 downto 0):=X"0000";
signal data_wr_m : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal clk_en : std_LOGIC:='0'; 

COMPONENT i2c_master is
	GENERIC (
            input_clk : INTEGER := 50_000_000;
            bus_clk   : INTEGER := 400_000);  
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


Component clk_enabler is
	GENERIC (
		CONSTANT cnt_max : integer := 49999999);      --  1.0 Hz 
	port(	
		clock:		in std_logic;	 
		reset_n:       in std_logic;
		clk_en: 		out std_logic
	);
end Component;



BEGIN
process(iData, clk)
begin
	if(rising_edge(clk)) then
		if(iData(7)= '1') then
		data_sig <= "000000000"&iData(6 downto 0);
		end if;
	end if;
end process;
	
		Inst_clk_en_I2C: clk_enabler
	GENERIC MAP(cnt_max => 50000)    -- Clk_en 1 second
	port map(	
		clock			=> CLK, 
		reset_n		=> '1',
		clk_en		=> clk_en
	);
	
	
	
	
process(byteSel, iData)
 begin
    case byteSel is
       when 0  => data_wr <= X"76";
       when 1  => data_wr <= X"76";
       when 2  => data_wr <= X"76";
       when 3  => data_wr <= X"7A";
       when 4  => data_wr <= X"FF";
       when 5  => data_wr <= X"77";
       when 6  => data_wr <= X"00";
       when 7  => data_wr <= X"79";
       when 8  => data_wr <= X"00";
       when 9  => data_wr <= X"0"&data_sig(15 downto 12);
       when 10 => data_wr <= X"0"&data_sig(11 downto 8);
       when 11 => data_wr <= X"0"&data_sig(7 downto 4);
       when 12 => data_wr <= X"0"&data_sig(3 downto 0);
       when others => data_wr <= X"76";
   end case;
end process;

      
Inst_i2c_master: i2c_master
	GENERIC map(input_clk => 100_000_000,
                bus_clk   => 50_000)
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
	  
        
process(clk, reset)
begin
    if rising_edge(clk) then
        --iData   <= iData;
        addr    <= address;
    end if;

    if(rising_edge(clk)) then -- and clk_en = '1') then  -- added a clock en
		--if(iData(7)= '1') then    -- checking if data is meant for 7 seg
			case state is 
				when start =>
					if reset = '1' then	
						byteSel <= 0;	
						ena 	<= '0'; 
						state   <= start; 
					else
						ena <= '1';  -- enable for communication with master
						rw <= '0';   -- write
						data_wr_m <= data_wr;   --data to be written 
						addr_master <= addr; 
						state   <= ready;  -- ready to write           
					end if;

				when ready =>		
					if busy = '1' then                      -- state to signal ready for transaction
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
					if byteSel < 12 then
						byteSel <= byteSel + 1;
					else	 
						byteSel <= 9;           
					end if; 		  
				state <= start; 
			when others => null;

			end case;  
		--end if;
    end if;  
end process;         
end user_logic; 