LOAD DATA
INFILE *
APPEND
INTO TABLE PURCHASE_ORDER205_STG
FIELDS TERMINATED BY "," 
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
invoice_type,
invoice_num,
curr_code,
vendor_number,
vendor_site,
payment_term,
line_number,
description,
header_amount,
line_amount,
org_id,
source,
distribution_set_name,
dist_set_id,
vendor_id,
vendor_site_id,
payment_term_id,
source_id,
created_by,
creation_date,
last_updated_by,
last_updated_date,
last_updated_login,
request_id,
record_status,
error_message)
