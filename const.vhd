library IEEE;
use IEEE.STD_LOGIC_1164.all;

package const is

	constant REG_PC : std_logic_vector(3 downto 0) := "1000";
	constant REG_T : std_logic_vector(3 downto 0) := "1001";
	constant REG_SP : std_logic_vector(3 downto 0) := "1010";
	constant REG_RA : std_logic_vector(3 downto 0) := "1011";
	constant REG_IH : std_logic_vector(3 downto 0) := "1100";

	constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
	constant ALU_AND : std_logic_vector(3 downto 0) := "0001";
   constant ALU_MOVE : std_logic_vector(3 downto 0) := "0010";
	constant ALU_NOT : std_logic_vector(3 downto 0) := "0011";
	constant ALU_OR : std_logic_vector(3 downto 0) := "0100";
	constant ALU_SLL : std_logic_vector(3 downto 0) := "0101";
	constant ALU_SRA : std_logic_vector(3 downto 0) := "0110";
	constant ALU_SRL : std_logic_vector(3 downto 0) := "0111";
	constant ALU_SUB : std_logic_vector(3 downto 0) := "1000";
	constant ALU_XOR : std_logic_vector(3 downto 0) := "1001";
	constant ALU_CMP : std_logic_vector(3 downto 0) := "1010";
	constant ALU_SLT : std_logic_vector(3 downto 0) := "1011";
	constant ALU_SLTU : std_logic_vector(3 downto 0) := "1100";
	
	constant read_uart   : std_logic_vector(4 downto 0) := "00010";
	constant write_uart  : std_logic_vector(4 downto 0) := "00001";
	constant test_uart   : std_logic_vector(4 downto 0) := "00110";
	constant read_flash  : std_logic_vector(4 downto 0) := "01010";
	constant write_flash : std_logic_vector(4 downto 0) := "01001";
	constant read_key    : std_logic_vector(4 downto 0) := "01110";
	constant write_vga   : std_logic_vector(4 downto 0) := "10001";	
	constant read_ram    : std_logic_vector(4 downto 0) := "11110";
	constant write_ram   : std_logic_vector(4 downto 0) := "11101";
	constant wait_ram    : std_logic_vector(4 downto 0) := "11111";

	constant uart_ready : std_logic_vector(2 downto 0) := "000";
	constant read_next  : std_logic_vector(2 downto 0) := "001";
	constant write_next : std_logic_vector(2 downto 0) := "010";
	constant write_tbre : std_logic_vector(2 downto 0) := "011";
	constant write_tsre : std_logic_vector(2 downto 0) := "100";
	
	type INSARR is array(0 to 10) of std_logic_vector(15 downto 0);
	constant ins_array : INSARR :=(
		x"6e4e",  -- LI R6 4e
		x"f601",  -- MTIH R6
		x"63fe",  -- ADDSP FE
		x"6e10",  -- LI R6 10
		x"d600",  -- SW_SP R6 00
		x"ee40",  -- MFPC R6
		x"4eff",  -- ADDIU R6 FF
		x"d601",  -- SW_SP R6 01
		x"6e4e",  -- LI R6 4e
		x"ee00",  -- JR R6
		x"0800"   -- NOP
	);
end const;

package body const is

end const;
