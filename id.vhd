----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:10:14 11/11/2016 
-- Design Name: 
-- Module Name:    id - Behavioral 
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
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use const.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity id is
port(
	ins_addr_i : in std_logic_vector(15 downto 0);
	instruction : in std_logic_vector(15 downto 0);
	
	reg_data1_i : in std_logic_vector(15 downto 0);
	reg_data2_i : in std_logic_vector(15 downto 0);
	
	ex_write_reg_num : in std_logic_vector(3 downto 0);
	ex_write_data : in std_logic_vector(15 downto 0);
	
	mem_write_reg_num : in std_logic_vector(3 downto 0);
	mem_write_data : in std_logic_vector(15 downto 0);
	
	reg_read_num1 : buffer std_logic_vector(3 downto 0);
	reg_read_num2 : buffer std_logic_vector(3 downto 0);
	
	pc_branch_enable : out std_logic;
	pc_branch : buffer std_logic_vector(15 downto 0);
		
	operand1 : out std_logic_vector(15 downto 0);
	operand2 : out std_logic_vector(15 downto 0);
	ALU_op : out std_logic_vector(3 downto 0);
	
	mem_op : out std_logic;
	
	write_reg_addr : out std_logic_vector(3 downto 0)
	
);
end id;

architecture Behavioral of id is
signal op : std_logic_vector(4 downto 0) := instruction(15 downto 11);
signal rx : std_logic_vector(3 downto 0) := '0' & instruction(10 downto 8);
signal ry : std_logic_vector(3 downto 0) := '0' & instruction(7 downto 5);
signal rz : std_logic_vector(3 downto 0) := '0' & instruction(4 downto 2);
signal imm : std_logic_vector(15 downto 0);

signal reg_data1 : std_logic_vector(15 downto 0);
signal reg_data2 : std_logic_vector(15 downto 0);

begin 
	
	process (reg_data1_i, ex_write_reg, ex_write_reg_num, ex_write_data, mem_write_data, mem_write_reg, mem_write_reg_num)
	begin
		if(reg_read_num1 = ex_write_reg_num) then
			reg_data1 <= ex_write_data;
		elsif(reg_read_num1 = mem_write_reg_num) then
			reg_data1 <= mem_write_data;
		else
			reg_data1 <= reg_data1_i;
		end if;
	end process;
	
	process (reg_data2_i, ex_write_reg, ex_write_reg_num, ex_write_data, mem_write_data, mem_write_reg, mem_write_reg_num)
	begin
		if(reg_read_num2 = ex_write_reg_num) then
			reg_data2 <= ex_write_data;
		elsif(reg_read_num2 = mem_write_reg_num) then
			reg_data2 <= mem_write_data;
		else
			reg_data2 <= reg_data1_i;
		end if;
	end process;
	
	process (op)
		variable temp : std_logic_vector(15 downto 0);
	begin
		reg_read_num1 <= (others => '1');
		reg_read_num2 <= (others => '1');
		
		pc_branch_enable <= '0';
		pc_branch <= (others => '0');
		
		operand1 <= (others => '0');
		operand2 <= (others => '0');
		ALU_op <= (others => '1');
		
		mem_op <= (others => '0');
		
		write_reg_addr <= (others => '1');
		
		case op is 
			when "01001" => --ADDIU 
				reg_read_num1 <= rx;
				
				operand1 <= reg_data1;
				operand2(15 downto 8) <= (others => instruction(7));
				operand2(7 downto 0) <= instruction(7 downto 0);
				ALU_op <= "0000";
				
				write_reg_addr <= rx;
			when "01000" => --AUUID3
				reg_read_num1 <= rx;
				
				operand1 <= reg_data1;
				operand2(15 downto 4) <= (others => instruction(3));
				operand2(3 downto 0) <= instruction(3 downto 0);
				ALU_op <= "0000";
				
				write_reg_addr <= ry;
			when "01100" => 
				if(rx = "000") then --BTEQZ
					reg_read_num1 <= REG_T;
					if(reg_data1 = "0000000000000000") then 
						pc_branch_enable <= '1';
						pc_branch(15 downto 8) <= (others => instruction(7));
						pc_branch(7 downto 0) <= instruction(7 downto 0);
						pc_branch <= ins_addr_i + pc_branch;
					end if;
				elsif(rx = "011") then --ADDSP
					reg_read_num1 <= REG_SP;
					
					operand1 <= reg_data1;
					operand2(15 downto 8) <= (others => instruction(7));
					operand2(7 downto 0) <= instruction(7 downto 0);
					ALU_op <= "0000";
					
					write_reg_addr <= REG_SP;
				elsif(rx = "001") then --BTNEZ
					reg_read_num1 <= REG_T;
					if(not(reg_data1 = "0000000000000000")) then 
						pc_branch_enable <= '1';
						pc_branch(15 downto 8) <= (others => instruction(7));
						pc_branch(7 downto 0) <= instruction(7 downto 0);
						pc_branch <= ins_addr_i + pc_branch;
					end if;
					
				end if;
				
			when "11100" => --ADDU
				reg_read_num1 <= rx;
				reg_read_num2 <= ry;
				
				operand1 <= reg_data1;
				operand2 <= reg_data2;
				ALU_op <= "0000";
				
				write_reg_addr <= rz;
			when "11101" =>
				if(instruction(4 downto 0) = "01100") then --AND
					reg_read_num1 <= rx;
					reg_read_num2 <= ry;
					
					operand1 <= reg_data1;
					operand2 <= reg_data2;
					ALU_op <= "0010";
					
					write_reg_addr <= rx;
				elsif(instruction(4 downto 0) = "01010") then --CMP
					reg_read_num1 <= rx;
					reg_read_num2 <= ry;
					
					operand1 <= reg_data1;
					operand2 <= reg_data2;
					ALU_op <= "1010";
					
					write_reg_addr <= REG_T;
				elsif(instruction(4 downto 0) = "01011") then --NEG
					reg_read_num1 <= ry;
					
					operand1 <= (others => 0);
					operand2 <= reg_data1;
					ALU_op <= "1000";
					
					write_reg_addr <= rx;
				elsif(instruction(4 downto 0) = "01101") then --OR
					reg_read_num1 <= rx;
					reg_read_num2 <= ry;
					
					operand1 <= reg_data1;
					operand2 <= reg_data2;
					ALU_op <= "0100";
					
					write_reg_addr <= rx;
					
					
				end if;
			when "00010" => --B
				pc_branch_enable <= '1';
				pc_branch <= ins_addr_i + std_logic_vector(resize(signed(instruction(10 downto 0)), 16));
			when "00100" => --BEQZ
				reg_read_num1 <= rx;
				if(reg_data1 = "0000000000000000") then 
					pc_branch_enable <= '1';
					pc_branch(15 downto 8) <= (others => instruction(7));
					pc_branch(7 downto 0) <= instruction(7 downto 0);
					pc_branch <= ins_addr_i + pc_branch;
				end if;
			when "00101" => --BNEZ
				reg_read_num1 <= rx;
				if(not(reg_data1 = "0000000000000000")) then 
					pc_branch_enable <= '1';
					pc_branch(15 downto 8) <= (others => instruction(7));
					pc_branch(7 downto 0) <= instruction(7 downto 0);
					pc_branch <= ins_addr_i + pc_branch;
				end if;
			when "11101"
			
				
			when others =>
		end case;
				
	end process;  



end Behavioral;

