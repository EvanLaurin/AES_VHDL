----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MergeBytes is
	port (clk: in std_logic;
			s	: in std_logic_vector(3 downto 0);
			a 	: in std_logic_vector(7 downto 0);
			q	: out std_logic_vector(127 downto 0)
			);
end MergeBytes;

architecture Behavioral of MergeBytes is

type t_state is array (0 to 15) of std_logic_vector(7 downto 0);
signal state : t_state;

begin

q <= state(0) & state(1) & state(2) & state(3) & 
     state(4) & state(5) & state(6) & state(7) & 
     state(8) & state(9) & state(10) & state(11) & 
     state(12) & state(13) & state(14) & state(15);

change_state: process(clk)
begin
	if rising_edge(clk) then
		case s is
			when "0000" => state(0) <= a;   
			when "0001" => state(1) <= a;
			when "0010" => state(2)	<= a; 
			when "0011" => state(3) <= a; 
			when "0100" => state(4) <= a; 
			when "0101" => state(5) <= a; 
			when "0110" => state(6) <= a; 
			when "0111" => state(7) <= a; 
			when "1000" => state(8) <= a; 
			when "1001" => state(9) <= a; 
			when "1010" => state(10)<= a; 
			when "1011" => state(11)<= a; 
			when "1100" => state(12)<= a;
			when "1101" => state(13)<= a;
			when "1110" => state(14)<= a;
			when "1111" => state(15)<= a;
			when others => null; 
		end case;
	end if;
end process change_state;
end Behavioral;

