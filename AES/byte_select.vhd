-------------------------------------------------------------

-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ByteSelect is
	port (s	: in std_logic_vector(3 downto 0);
			a 	: in std_logic_vector(127 downto 0);
			q	: out std_logic_vector(7 downto 0)
			);
end ByteSelect;

architecture Behavioral of ByteSelect is
begin
	process(s, a)
	begin
		case s is
			when "0000" => q <= a(7 downto 0);   
			when "0001" => q <= a(15 downto 8);  
			when "0010" => q <= a(23 downto 16); 
			when "0011" => q <= a(31 downto 24); 
			when "0100" => q <= a(39 downto 32); 
			when "0101" => q <= a(47 downto 40); 
			when "0110" => q <= a(55 downto 48); 
			when "0111" => q <= a(63 downto 56); 
			when "1000" => q <= a(71 downto 64); 
			when "1001" => q <= a(79 downto 72); 
			when "1010" => q <= a(87 downto 80); 
			when "1011" => q <= a(95 downto 88); 
			when "1100" => q <= a(103 downto 96);
			when "1101" => q <= a(111 downto 104);
			when "1110" => q <= a(119 downto 112);
			when "1111" => q <= a(127 downto 120);
			when others => q <= (others => '0'); 
		end case;
	end process;
end Behavioral;
