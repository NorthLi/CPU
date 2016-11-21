--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:22:32 11/20/2016
-- Design Name:   
-- Module Name:   E:/EDA/Xilinx/Project/THINPAD/test0.vhd
-- Project Name:  THINPAD
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Thinpad
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test0 IS
END test0;
 
ARCHITECTURE behavior OF test0 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Thinpad
    PORT(
         clk_0 : IN  std_logic;
         rst : IN  std_logic;
         ram1_oe : OUT  std_logic;
         ram1_we : OUT  std_logic;
         ram1_en : OUT  std_logic;
         ram1_address : OUT  std_logic_vector(17 downto 0);
         ram1_data : INOUT  std_logic_vector(15 downto 0);
         rdn : OUT  std_logic;
         wrn : OUT  std_logic;
         data_ready : IN  std_logic;
         tbre : IN  std_logic;
         tsre : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_0 : std_logic := '0';
   signal rst : std_logic := '0';
   signal data_ready : std_logic := '0';
   signal tbre : std_logic := '0';
   signal tsre : std_logic := '0';

	--BiDirs
   signal ram1_data : std_logic_vector(15 downto 0);

 	--Outputs
   signal ram1_oe : std_logic;
   signal ram1_we : std_logic;
   signal ram1_en : std_logic;
   signal ram1_address : std_logic_vector(17 downto 0);
   signal rdn : std_logic;
   signal wrn : std_logic;

   -- Clock period definitions
   constant clk_0_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Thinpad PORT MAP (
          clk_0 => clk_0,
          rst => rst,
          ram1_oe => ram1_oe,
          ram1_we => ram1_we,
          ram1_en => ram1_en,
          ram1_address => ram1_address,
          ram1_data => ram1_data,
          rdn => rdn,
          wrn => wrn,
          data_ready => data_ready,
          tbre => tbre,
          tsre => tsre
        );

   -- Clock process definitions
   clk_0_process :process
   begin
		clk_0 <= '0';
		wait for 10ns;
		clk_0 <= '1';
		wait for 10ns;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '0';
		wait for 40ns;
		rst <= '1';
		wait;
   end process;

END;
