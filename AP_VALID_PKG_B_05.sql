create or replace package body AP_VALID_PKG_05 as 
  gn_request_id NUMBER;
  gn_user_id NUMBER;
  gn_org_id NUMBER;
  gn_organization_id NUMBER;
  gc_err_status VARCHAR2(10) := 'ERROR';
  gc_new_status VARCHAR2(10) := 'NEW';

  Procedure main (
    p_errbuf OUT NOCOPY Varchar2,
    p_retcode OUT NOCOPY Number
  ) IS 

    --Header Interface Cursor
    Cursor cur_ap_invoice_header IS
      SELECT DISTINCT
        XAPIS.invoice_type,
        XAPIS.invoice_num,
        XAPIS.curr_code,
        XAPIS.vendor_number,
        XAPIS.vendor_site,
        XAPIS.payment_term,
        XAPIS.header_amount
      FROM
        AP_INVOICE_IFACE_STG_05 XAPIS;

    --Lines Interface Cursor
    Cursor cur_ap_invoice_lines IS
      SELECT
        XAPIS.line_number,
        XAPIS.line_amount,
        XAPIS.description
      FROM
        AP_INVOICE_IFACE_STG_05 XAPIS;
    
    --Local Variables
    ln_batch_id Number;
    l_error_flag Number := 0;
    ln_ap_invoice_id NUMBER;
    ln_ap_line_id NUMBER;
    counter NUMBER := 0;

  BEGIN 
    mo_global.init('PO');
    mo_global.set_policy_context('S', FND_PROFILE.VALUE('USER_ID'));
    fnd_file.put_line (fnd_file.output, FND_PROFILE.VALUE('USER_ID'));
    gn_request_id := FND_GLOBAL.CONC_REQUEST_ID;
    gn_user_id := NVL(FND_PROFILE.VALUE('USER_ID'), -1);
    gn_org_id := NVL(FND_PROFILE.VALUE('ORG_ID'), 204);
    gn_organization_id := TO_NUMBER (OE_PROFILE.VALUE('SO_ORGANIZATION_ID'));

    -- Get Batch ID from standard sequence
    SELECT MSC_ST_BATCH_ID_S.NEXTVAL INTO ln_batch_id FROM dual;

    dbms_output.put_line(ln_batch_id);
    FND_FILE.PUT_LINE(FND_FILE.LOG, 'Batch ID : ' || ln_batch_id);
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT, 'Batch ID : ' || ln_batch_id);

    -- For loop for insertion of header records in interface table
    FOR i IN cur_ap_invoice_header LOOP 
      counter := 0;

      -- Get Interface Invoice ID from sequence
      SELECT ap_invoices_interface_S.NEXTVAL INTO ln_ap_invoice_id FROM dual;

      BEGIN 
        fnd_file.put_line(fnd_file.LOG, 'Inserting Data');

        INSERT INTO ap_invoices_interface (
          invoice_id,
          invoice_num,
          invoice_type_lookup_code,
          invoice_date,
          payment_currency_code,
          invoice_amount,
          vendor_num,
          vendor_site_code,
          settlement_priority,
          org_id,
          created_by,
          creation_date,
          last_update_login,
          last_update_date,
          last_updated_by
        )
        VALUES (
          ln_ap_invoice_id,
          i.invoice_num,
          i.invoice_type,
          SYSDATE,
          i.curr_code,
          i.header_amount,
          i.vendor_number,
          i.vendor_site,
          i.payment_term,
          gn_org_id,
          gn_user_id,
          SYSDATE,
          gn_user_id,
          SYSDATE,
          gn_user_id
        );

        -- For loop for insertion of line records in interface table
        FOR j IN cur_ap_invoice_lines LOOP 
          -- Get Interface Invoice Line ID from sequence
          SELECT ap_invoice_lines_interface_S.NEXTVAL INTO ln_ap_line_id FROM dual;

          counter := counter + 1;

          INSERT INTO ap_invoice_lines_interface (
            invoice_id,
            invoice_line_id,
            line_number,
            line_type_lookup_code,
            amount,
            accounting_date,
            description,
            org_id,
            created_by,
            creation_date,
            last_update_login,
            last_updated_by,
            last_update_date
          )
          VALUES (
            ln_ap_invoice_id,
            ln_ap_line_id,
            j.line_number,
            'ITEM',
            j.line_amount,
            SYSDATE,
            j.description,
            gn_org_id,
            gn_user_id,
            SYSDATE,
            gn_user_id,
            gn_user_id,
            SYSDATE
          );
        END LOOP; -- End of line records loop

      END;
    END LOOP; -- End of header records loop

    COMMIT;

  END main;

END AP_VALID_PKG_05;