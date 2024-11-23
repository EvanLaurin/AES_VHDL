----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RotateLeft is
	Port (byte_in  : in std_logic_vector(31 downto 0);
			byte_out  : out std_logic_vector(31 downto 0)
			);   
end RotateLeft;

architecture Structural of RotateLeft is

signal b0, b1, b2, b3 : std_logic_vector(7 downto 0);

begin
	b0 <= byte_in(31 downto 24);
	b1 <= byte_in(23 downto 16);
	b2 <= byte_in(15 downto 8);
	b3 <= byte_in(7 downto 0);

	byte_out <= b1 & b2 & b3 & b0;
end Structural;

