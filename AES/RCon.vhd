----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCon is
	port( clk	: in std_logic;
			reset	: in std_logic;
			inc 	: in std_logic;
			r_con	: out std_logic_vector(7 downto 0)
			);
end RCon;

architecture Behavioral of RCon is

signal round_const_next : std_logic_vector(7 downto 0);
signal round_const 		: std_logic_vector(7 downto 0);

component ByteMultBy2
    Port ( Byte 	: in  STD_LOGIC_VECTOR (7 downto 0);
           Result : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end component;

begin

bmb2 : ByteMultBy2
	port map(round_const, round_const_next);

inc_proc : process(clk)
 begin
	  if rising_edge(clk) then
			if reset = '1' then
				 round_const <= x"01";
			elsif inc = '1' then
				 round_const <= round_const_next;
			end if;
	  end if;
 end process inc_proc;
 r_con <= round_const;
end Behavioral;

