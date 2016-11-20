--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package const is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

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
	constant ALU_SLTI : std_logic_vector(3 downto 0) := "1100";
	
	constant read_pc : std_logic_vector(2 downto 0) := "000";
	constant read_ram : std_logic_vector(2 downto 0) := "001";
	constant write_ram : std_logic_vector(2 downto 0) := "010";
	constant read_uart : std_logic_vector(2 downto 0) := "011";
	constant write_uart : std_logic_vector(2 downto 0) := "100";
	constant test_uart : std_logic_vector(2 downto 0) := "101";		
	constant wrong_type : std_logic_vector(2 downto 0) := "111";
	
	constant uart_ready : std_logic_vector(2 downto 0) := "000";
	constant read_next : std_logic_vector(2 downto 0) := "001";
	constant write_next : std_logic_vector(2 downto 0) := "010";
	constant write_wait : std_logic_vector(2 downto 0) := "011";			
	constant write_tbre : std_logic_vector(2 downto 0) := "100";
	constant write_tsre : std_logic_vector(2 downto 0) := "101";
	
	constant ZERO14 : std_logic_vector(15 downto 2) := "00000000000000";
	constant ZERO15 : std_logic_vector(15 downto 1) := "000000000000000";
	
end const;

package body const is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end const;
