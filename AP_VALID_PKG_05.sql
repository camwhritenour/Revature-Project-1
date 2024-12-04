
CREATE OR REPLACE PACKAGE AP_VALID_PKG_05 
AS
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Package for Inserting Data from Staging table to Interface Table
-- Author  : Cameron Whritenour
-- Package Specification and Body AP_VALID_PKG_05
-- History----Version---Author---Comment
-- 28/4/2015   1.0      Cameron   Current as per specification provided
--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This procedure will Insert data into Purchasing Interface table
   
   Procedure main (p_errbuf  OUT NOCOPY Varchar2,
                   p_retcode OUT NOCOPY Number);
                 
end AP_VALID_PKG_05;
