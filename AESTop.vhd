----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AESTop is
port (	clk, reset 	: in std_logic;
			text_in  	: in std_logic_vector(127 downto 0);
			key  			: in std_logic_vector(127 downto 0);
			text_out  	: out std_logic_vector(127 downto 0)
			);
end AESTop;

architecture Behavioral  of AESTop is

component Counter_6 
 Port (	clk 		: in std_logic;                   		-- Clock input
         reset 	: in std_logic;                		 	-- Reset input
			en			: in std_logic;								-- Enable input
         count 	: out std_logic_vector(5 downto 0); 	-- 6-bit counter output
         carry_out: out std_logic             				-- Carry-out signal
         );
end component;

component Counter_4
 Port (	clk 			: in std_logic;                   
         reset 		: in std_logic;
			en				: in std_logic;			
         count 		: out std_logic_vector(3 downto 0);
         carry_out 	: out std_logic             
         );
end component;

component AddRoundKey
	port (state_in  	: in std_logic_vector(127 downto 0);
			key  			: in std_logic_vector(127 downto 0);
			state_out  	: out std_logic_vector(127 downto 0)
			);
end component;

component RegA
	Port (clk, load   : in std_logic;
			out_select	: in std_logic;
			in_select	: in std_logic;
			state_in_0  : in std_logic_vector(127 downto 0);
			state_in_1  : in std_logic_vector(127 downto 0);
			byte_select	: in std_logic_vector(3 downto 0);
			byte_out	 	: out std_logic_vector(7 downto 0)
			);   
end component;

component SubBytes
    Port ( 
        byte_in  : in std_logic_vector(7 downto 0);
        byte_out  : out std_logic_vector(7 downto 0));
end component;

component RegB
	Port (clk, reg_out: in std_logic;
			load			: in std_logic;
			byte_in	 	: in std_logic_vector(7 downto 0);
			byte_select	: in std_logic_vector(3 downto 0);
			state_out  	: out std_logic_vector(127 downto 0)
			);   
end component;

component ShiftRows
	Port ( 	state_in  : in std_logic_vector(127 downto 0);
				state_out  : out std_logic_vector(127 downto 0));         
end component;

component MixColumns
	Port (state_in  : in std_logic_vector(127 downto 0);
			state_out  : out std_logic_vector(127 downto 0)
			);     
end component;


signal Add_key_out 	: std_logic_vector(127 downto 0) := (others => '0');
signal step				: std_logic_vector(5 downto 0) := (others => '0');
signal step_out		: std_logic;
signal round			: std_logic_vector(3 downto 0) := (others => '0');
signal round_out		: std_logic;
signal a_in				: std_logic;
signal a_out			: std_logic;
signal a_select		: std_logic;
signal a_data_out		: std_logic_vector(7 downto 0) := (others => '0');
signal sub_bytes_out	: std_logic_vector(7 downto 0) := (others => '0');
signal b_in				: std_logic; 
signal b_out			: std_logic; 
signal out_reg_state	: std_logic_vector(127 downto 0) := (others => '0');
signal shift_rows_out: std_logic_vector(127 downto 0) := (others => '0');
signal mix_col_out	: std_logic_vector(127 downto 0) := (others => '0');
signal round_key_in	: std_logic_vector(127 downto 0) := (others => '0');
signal round_state 	: std_logic_vector(127 downto 0) := (others => '0');
signal halt				: std_logic; 

begin

Step_reg 		: Counter_6
	port map(clk, reset, not halt, step, step_out);
Round_reg 		: Counter_4
	port map(clk, reset, step_out, round, round_out);
Add_key 			: AddRoundKey
	port map(text_in, key, Add_key_out);
A_reg		 		: RegA -- clk, load, out_select, in_select, state_in_0, state_in_1, byte_select, byte_out	
	port map(clk, a_in, a_out, a_select, Add_key_out, round_state, step(5 downto 2), a_data_out);
Sub_bytes		: SubBytes
	port map(a_data_out, sub_bytes_out);
B_reg			 	: RegB -- clk, load, out_select, byte_in, byte_select, state_out	
	port map(clk, b_in, b_out, sub_bytes_out, step(5 downto 2), out_reg_state);
Shift_rows		: ShiftRows
	port map(out_reg_state, shift_rows_out);
Mix_columns		: MixColumns
	port map(shift_rows_out, mix_col_out);
Add_round_key	: AddRoundKey
	port map(round_key_in, key, round_state);



process(clk, reset)
	begin
		if reset = '1' then
			-- Initialize signals on reset
			a_in 	<= '0';
			a_out <= '0';
			b_in 	<= '0';
			b_out <= '0';
			halt 	<= '0';
			a_select    <= '0';
			round_key_in <= (others => '0');
		elsif rising_edge(clk) then
			-- Manage rounds and steps using control signals
			
			
			if step(5 downto 2) = "0000" then
				a_select <= '0';
			else 
				a_select <= '1';
			end if;
			
			-- Final round condition (e.g., 10th round in AES-128)
			if step(5 downto 2) = "1001" then
				round_key_in <= shift_rows_out;
			else 
				round_key_in <= mix_col_out;
			end if;
			
			if step(5 downto 2) = "1010" then
				halt <= '1';
			else 
				halt <= '0';
			end if;
			
			
			-- Step-by-step control logic			
			case step(1 downto 0) is
				when "00" => 
					a_in 	<= '1';
					a_out <= '0';
					b_in 	<= '0';
					b_out <= '0';

				when "01" => 
					a_in 	<= '0';
					a_out <= '1';
					b_in 	<= '1';
					b_out <= '0';
					
				when "10" => 
					a_in 	<= '0';
					a_out <= '0';
					b_in 	<= '0';
					b_out <= '0';
					
				when "11" => 
					a_in 	<= '0';
					a_out <= '0';
					b_in 	<= '0';
					b_out <= '0';
				when others =>
					null;
			end case;
		end if;
	end process;
	
	text_out <= round_state;
	
end Behavioral;

