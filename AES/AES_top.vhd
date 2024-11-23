----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.all;
package AES_pkg is
	constant key: std_logic_vector(127 downto 0):= X"000102030405060708090A0B0C0D0E0F";
end AES_pkg; 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
library work;
 use work.AES_pkg.all;

entity AES_top is
	port (clk		: in std_logic;
			reset		: in std_logic;
			end_sig	: out std_logic;
			text_in	: in std_logic_vector(127 downto 0);
			text_out	: out std_logic_vector(127 downto 0)
			);
end AES_top;

architecture Structural of AES_top is

component KeyScheduler
	port (clk			: in 	std_logic;
			reset			: in 	std_logic;
			counter		: in 	std_logic_vector(7 downto 0);
			key			: in 	std_logic_vector(127 downto 0);
			key_out	 	: out std_logic_vector(127 downto 0)
			);
end component;

component ByteSelect is
	port (s	: in std_logic_vector(3 downto 0);
			a 	: in std_logic_vector(127 downto 0);
			q	: out std_logic_vector(7 downto 0)
			);
end component;

component MergeBytes
	port (clk: in std_logic;
			s	: in std_logic_vector(3 downto 0);
			a 	: in std_logic_vector(7 downto 0);
			q	: out std_logic_vector(127 downto 0)
			);
end component;

component SubBytes
    Port ( 
        byte_in  : in std_logic_vector(7 downto 0);
        byte_out  : out std_logic_vector(7 downto 0));
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

signal counter			: std_logic_vector(7 downto 0) := "00000000";
signal round_key	 	: std_logic_vector(127 downto 0);
signal round_text 	: std_logic_vector(127 downto 0);
signal sub_byte_in	: std_logic_vector(7 downto 0);
signal sub_byte_out	: std_logic_vector(7 downto 0);
signal shift_rows_in	: std_logic_vector(127 downto 0);
signal shift_rows_out: std_logic_vector(127 downto 0);
signal mix_cols_out	: std_logic_vector(127 downto 0);

signal step	: std_logic_vector(3 downto 0);
signal round: std_logic_vector(3 downto 0);


begin

step 	<=	counter(3 downto 0); 
round <=	counter(7 downto 4); 

byte_select : ByteSelect
	port map(step, round_text, sub_byte_in);
sub_bytes	: SubBytes
	port map(sub_byte_in, sub_byte_out);
merge_bytes : MergeBytes
	port map(clk, step, sub_byte_out, shift_rows_in);
shift_rows	: ShiftRows
	port map(shift_rows_in, shift_rows_out);
mix_cols		: MixColumns
	port map(shift_rows_out, mix_cols_out);
key_schedule: KeyScheduler
	port map(clk, reset, counter, key, round_key);


increment_counter : process(clk)
begin
	if falling_edge(clk) then
		if reset = '1' then
			counter <= (others => '0');
		else 
			counter <= counter + 1;
		end if;
	end if;
end process increment_counter;

change_round : process(clk)
begin
	if rising_edge(clk) then
		if round = "0000" then
			round_text <= key xor text_in;
			end_sig <= '0';
		elsif	round = "1001" then
			if	step = "0000" then
				round_text <= round_key xor mix_cols_out;
			end if;
			end_sig <= '1';
		else
			if	step = "0000" then
				round_text <= round_key xor mix_cols_out;
			end if;
			end_sig <= '0';
		end if;
	end if;
end process change_round;

text_out <= round_text;

end Structural;

