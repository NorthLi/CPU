----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:51:45 11/27/2016 
-- Design Name: 
-- Module Name:    D_RAM_controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity D_RAM_controller is
	PORT (
    clka : IN STD_LOGIC;
	status : in std_logic_vector(4 downto 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end D_RAM_controller;

architecture Behavioral of D_RAM_controller is
	component D_RAM is
		port(
			clka : IN STD_LOGIC;
			ena : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			clkb : IN STD_LOGIC;
			enb : in std_logic;
			addrb : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
			doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;
		
	signal addra : std_logic_vector(14 downto 0) := (others => '0');
	signal wea : std_logic_vector(0 downto 0);

begin

	u1 : D_RAM port map(
		clka => clka,
		ena => '1',
		wea => wea,
		addra => addra,
		dina => dina,
		clkb => clkb,
		enb => '1',
		addrb => addrb,
		doutb => doutb
	);
	
	process(clka)
	begin
		if clka'event and clka = '0' then
				if status(4 downto 2) = "100" then 
					wea <= "1";
				elsif status(4 downto 2) = "101" then
					addra <= dina(14 downto 0);
				else
					wea <= "0";
				end if;
		end if;
	end process;
			

end Behavioral;

