library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.const.all;

entity Identify is
port(
	pc_ID : in std_logic_vector(15 downto 0);
	ins_ID : in std_logic_vector(15 downto 0);
	
	datax_reg : in std_logic_vector(15 downto 0);
	datay_reg : in std_logic_vector(15 downto 0);
	
	rz_EX : in std_logic_vector(3 downto 0);
	din_EX : in std_logic_vector(15 downto 0);
	
	rz_MEM : in std_logic_vector(3 downto 0);
	dataz_MEM : in std_logic_vector(15 downto 0);
	
	rx_reg : buffer std_logic_vector(3 downto 0);
	ry_reg : buffer std_logic_vector(3 downto 0);
	
	pc_ctrl : out std_logic;
	pc_branch : buffer std_logic_vector(15 downto 0);
		
	datax_ID : out std_logic_vector(15 downto 0);
	datay_ID : out std_logic_vector(15 downto 0);
	op_ID : out std_logic_vector(3 downto 0);
	dataz_ID : out std_logic_vector(15 downto 0);
	
	we_ID, oe_ID : out std_logic;
	
	rx_ID, ry_ID : out std_logic_vector(3 downto 0);
	
	rz_ID : out std_logic_vector(3 downto 0)
);
end Identify;

architecture Behavioral of Identify is

signal op_ins : std_logic_vector(4 downto 0);
signal rx : std_logic_vector(3 downto 0);
signal ry : std_logic_vector(3 downto 0);
signal rz : std_logic_vector(3 downto 0);

signal reg_data1 : std_logic_vector(15 downto 0);
signal reg_data2 : std_logic_vector(15 downto 0);

begin 
	op_ins <= ins_ID(15 downto 11);
	rx <= '0' & ins_ID(10 downto 8);
	ry <= '0' & ins_ID(7 downto 5);
	rz <= '0' & ins_ID(4 downto 2);
	process (datax_reg, rz_EX, din_EX, dataz_MEM, rz_MEM, rx_reg)
	begin
		if(rx_reg = rz_EX) then
			reg_data1 <= din_EX;
		elsif(rx_reg = rz_MEM) then
			reg_data1 <= dataz_MEM;
		else
			reg_data1 <= datax_reg;
		end if;
	end process;
	
	process (datay_reg, rz_EX, din_EX, dataz_MEM, rz_MEM, ry_reg)
	begin
		if(ry_reg = rz_EX) then
			reg_data2 <= din_EX;
		elsif(ry_reg = rz_MEM) then
			reg_data2 <= dataz_MEM;
		else
			reg_data2 <= datay_reg;
		end if;
	end process;
	
	process (op_ins, ins_ID, rx, ry, rz, reg_data1, reg_data2, pc_ID)
		variable temp : std_logic_vector(15 downto 0);
	begin
		rx_reg <= (others => '1');
		ry_reg <= (others => '1');
		
		pc_ctrl <= '0';
		pc_branch <= (others => '0');
		
		datax_ID <= (others => '0');
		datay_ID <= (others => '0');
		op_ID <= (others => '1');
		
		we_ID <= '0';
		oe_ID <= '0';
		
		rx_ID <= (others => '1');
		ry_ID <= (others => '1');
		rz_ID <= (others => '1');
		dataz_ID <= (others => '0');
		case op_ins is 
			when "01001" => --ADDIU 
				rx_reg <= rx;
				rx_ID <= rx;
				
				datax_ID <= reg_data1;
				datay_ID(15 downto 8) <= (others => ins_ID(7));
				datay_ID(7 downto 0) <= ins_ID(7 downto 0);
				op_ID <= "0000";
				
				rz_ID <= rx;
			when "01000" => --AUUID3
				rx_reg <= rx;
				rx_ID <= rx;
				
				datax_ID <= reg_data1;
				datay_ID(15 downto 4) <= (others => ins_ID(3));
				datay_ID(3 downto 0) <= ins_ID(3 downto 0);
				op_ID <= "0000";
				
				rz_ID <= ry;
			when "01100" => 
				if(rx(2 downto 0) = "000") then --BTEQZ
					rx_reg <= REG_T;
					if(reg_data1 = "0000000000000000") then 
						pc_ctrl <= '1';
						temp(15 downto 8) := (others => ins_ID(7));
						temp(7 downto 0) := ins_ID(7 downto 0);
						pc_branch <= pc_ID + 1 + temp;
					end if;
				elsif(rx(2 downto 0) = "011") then --ADDSP
					rx_reg <= REG_SP;
					rx_ID <= REG_SP;
					
					datax_ID <= reg_data1;
					datay_ID(15 downto 8) <= (others => ins_ID(7));
					datay_ID(7 downto 0) <= ins_ID(7 downto 0);
					op_ID <= "0000";
					
					rz_ID <= REG_SP;
				elsif(rx(2 downto 0) = "001") then --BTNEZ
					rx_reg <= REG_T;
					if(not(reg_data1 = "0000000000000000")) then 
						pc_ctrl <= '1';
						temp(15 downto 8) := (others => ins_ID(7));
						temp(7 downto 0) := ins_ID(7 downto 0);
						pc_branch <= pc_ID + 1 + temp;
					end if;
				elsif(rx(2 downto 0) = "100") then --MTSP
					rx_reg <= rx;
					rx_ID <= rx;
					datax_ID <= reg_data1;
					op_ID <= "0010";
					
					rz_ID <= REG_SP;
				elsif(rx(2 downto 0) = "010") then --SW_RS
					rx_reg <= REG_SP;
					rx_ID <= REG_SP;
					ry_reg <= REG_RA;
					
					datax_ID <= reg_data1;
					datay_ID(15 downto 8) <= (others => ins_ID(7));
					datay_ID(7 downto 0) <= ins_ID(7 downto 0);
					op_ID <= "0000";
					
					we_ID <= '1';
					
					dataz_ID <= reg_data2;
				end if;
			when "11100" => 
				if(ins_ID(1 downto 0) = "01") then --ADDU
					rx_reg <= rx;
					rx_ID <= rx;
					ry_reg <= ry;
					ry_ID <= ry;
					
					datax_ID <= reg_data1;
					datay_ID <= reg_data2;
					op_ID <= "0000";
					
					rz_ID <= rz;
				elsif(ins_ID(1 downto 0) = "11") then --SUBU
					rx_reg <= rx;
					rx_ID <= rx;
					ry_reg <= ry;
					ry_ID <= ry;
					
					datax_ID <= reg_data1;
					datay_ID <= reg_data2;
					op_ID <= "1000";
				
					rz_ID <= rz;
				end if;
			when "11101" =>
				if(ins_ID(4 downto 0) = "01100") then --AND
					rx_reg <= rx;
					rx_ID <= rx;
					ry_reg <= ry;
					ry_ID <= ry;
					
					datax_ID <= reg_data1;
					datay_ID <= reg_data2;
					op_ID <= "0001";
					
					rz_ID <= rx;
				elsif(ins_ID(4 downto 0) = "01010") then --CMP
					rx_reg <= rx;
					rx_ID <= rx;
					ry_reg <= ry;
					ry_ID <= ry;
					
					datax_ID <= reg_data1;
					datay_ID <= reg_data2;
					op_ID <= "1010";
					
					rz_ID <= REG_T;
				elsif(ins_ID(4 downto 0) = "01011") then --NEG
					rx_reg <= ry;
					ry_ID <= ry;
					
					datax_ID <= (others => '0');
					datay_ID <= reg_data1;
					op_ID <= "1000";
					
					rz_ID <= rx;
				elsif(ins_ID(4 downto 0) = "01101") then --OR
					rx_reg <= rx;
					rx_ID <= rx;
					ry_reg <= ry;
					ry_ID <= ry;
					
					datax_ID <= reg_data1;
					datay_ID <= reg_data2;
					op_ID <= "0100";
					
					rz_ID <= rx;
				elsif(ins_ID(7 downto 5) = "110") then --JALR
					rx_reg <= rx;
				
					datax_ID <= (others => '0');
					datay_ID <= pc_ID + "10";
					op_ID <= "0000";
					
					pc_ctrl <= '1';
					pc_branch <= reg_data1;
					
					rz_ID <= REG_RA;
				elsif(ins_ID(7 downto 5) = "000") then --JR
					rx_reg <= rx;
					
					pc_ctrl <= '1';
					pc_branch <= reg_data1;
				elsif(ins_ID(7 downto 5) = "001") then --JRRA
					rx_reg <= REG_RA;
					
					pc_ctrl <= '1';
					pc_branch <= reg_data1;
				elsif(ins_ID(7 downto 5) = "010") then --MFPC
					rx_reg <= REG_PC;
					rx_ID <= REG_PC;
					datax_ID <= pc_ID + 1;
					op_ID <= "0010";
					
					rz_ID <= rx;
				end if;
			when "00010" => --B
				pc_ctrl <= '1';
				temp(15 downto 11) := (others => ins_ID(10));
				temp(10 downto 0) := ins_ID(10 downto 0);
				pc_branch <= pc_ID + 1 + temp;
			when "00100" => --BEQZ
				rx_reg <= rx;
				if(reg_data1 = "0000000000000000") then 
					pc_ctrl <= '1';
					temp(15 downto 8) := (others => ins_ID(7));
					temp(7 downto 0) := ins_ID(7 downto 0);
					pc_branch <= pc_ID + 1 + temp;
				end if;
				
			when "00101" => --BNEZ
				rx_reg <= rx;
				if(not(reg_data1 = "0000000000000000")) then 
					pc_ctrl <= '1';
					temp(15 downto 8) := (others => ins_ID(7));
					temp(7 downto 0) := ins_ID(7 downto 0);
					pc_branch <= pc_ID + 1 + temp;
				end if;
			when "01101" => --LI
				datax_ID <= (others => '0');
				datay_ID(15 downto 8) <= (others => '0');
				datay_ID(7 downto 0) <= ins_ID(7 downto 0);
				op_ID <= "0000";
				
				rz_ID <= rx;
			when "10011" => --LW
				rx_reg <= rx;
				rx_ID <= rx;
				
				datax_ID <= reg_data1;
				datay_ID(15 downto 5) <= (others => ins_ID(4));
				datay_ID(4 downto 0) <= ins_ID(4 downto 0);
				op_ID <= "0000";
				
				rz_ID <= ry;
				
				oe_ID <= '1';
			when "10010" => --LW_SP
				rx_reg <= REG_SP;
				rx_ID <= REG_SP;
			
				datax_ID <= reg_data1;
				datay_ID(15 downto 8) <= (others => ins_ID(7));
				datay_ID(7 downto 0) <= ins_ID(7 downto 0);
				op_ID <= "0000";
				
				rz_ID <= rx;
				
				oe_ID <= '1';
			when "11110" => 
				if(ins_ID(0) = '0') then --MFIH
					rx_reg <= REG_IH;
					rx_ID <= REG_IH;
					datax_ID <= reg_data1;
					op_ID <= "0010";
					
					rz_ID <= rx;
				elsif(ins_ID(0) = '1') then --MTIH
					rx_reg <= rx;
					rx_ID <= rx;
					datax_ID <= reg_data1;
					op_ID <= "0010";
					
					rz_ID <= REG_IH;
				end if;
			when "00110" => 
				if(ins_ID(1 downto 0) = "00") then --SLL
					rx_reg <= ry;
					rx_ID <= ry;
					
					datax_ID <= reg_data1;
					datay_ID(15 downto 4) <= (others => '0'); 
					if(ins_ID(4 downto 2) = "000") then 
						datay_ID(3 downto 0) <= "1000";
					else
						datay_ID(3 downto 0) <= '0' & ins_ID(4 downto 2);
					end if;
					op_ID <= "0101";
					
					rz_ID <= rx;
				elsif(ins_ID(1 downto 0) = "11") then --SRA
					rx_reg <= ry;
					rx_ID <= ry;
					
					datax_ID <= reg_data1;
					datay_ID(15 downto 4) <= (others => '0'); 
					if(ins_ID(4 downto 2) = "000") then 
						datay_ID(3 downto 0) <= "1000";
					else
						datay_ID(3 downto 0) <= '0' & ins_ID(4 downto 2);
					end if;
					op_ID <= "0110";
					
					rz_ID <= rx;
				end if;
			when "11011" => --SW
				rx_reg <= rx;
				rx_ID <= rx;
				ry_reg <= ry;
				
				datax_ID <= reg_data1;
				datay_ID(15 downto 5) <= (others => ins_ID(4));
				datay_ID(4 downto 0) <= ins_ID(4 downto 0);
				
				op_ID <= "0000";
				
				dataz_ID <= reg_data2;
				
				we_ID <= '1';
			when "11010" => --SW_SP
				rx_reg <= REG_SP;
				rx_ID <= REG_SP;
				ry_reg <= rx;
				
				datax_ID <= reg_data1;
				datay_ID(15 downto 8) <= (others => ins_ID(7));
				datay_ID(7 downto 0) <= ins_ID(7 downto 0);
				
				op_ID <= "0000";
				
				dataz_ID <= reg_data2;
				
				we_ID <= '1';
			when others =>
		end case;
				
	end process;  


end Behavioral;

