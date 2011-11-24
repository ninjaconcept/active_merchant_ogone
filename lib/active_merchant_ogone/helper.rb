module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Ogone
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          # see full parameter list in your Ogone Backend under 'Support' -> 'Integration & User manuals'

          # required
          mapping :order,    'ORDERID'
          mapping :account,  'PSPID'
          mapping :amount,   'AMOUNT'
          mapping :currency, 'CURRENCY'
          mapping :language, 'LANGUAGE'

          mapping :payment, 'PM'
          mapping :payment_list, 'PMLIST'
          mapping :payment_list_type, 'PMLISTTYPE'

          mapping :device, 'DEVICE' # e.g. 'mobile'; only works with paypal

          mapping :customer, :first_name => 'ECOM_BILLTO_POSTAL_NAME_FIRST',
                             :last_name  => 'ECOM_BILLTO_POSTAL_NAME_LAST',
                             :email      => 'EMAIL'

          mapping :billing_address, :city     => 'OWNERTOWN',
                                    :address1 => 'OWNERADDRESS',
                                    :address2 => 'OWNERADDRESS2',
                                    :zip      => 'OWNERZIP',
                                    :country  => 'OWNERCTY'

          mapping :shipping_address,  :first_name => 'ECOM_SHIPTO_POSTAL_NAME_FIRST',
                                      :last_name => 'ECOM_SHIPTO_POSTAL_NAME_LAST',
                                      :company => 'ECOM_SHIPTO_COMPANY',
                                      :phone_number => 'ECOM_SHIPTO_TELECOM_PHONE_NUMBER',
                                      :email => 'ECOM_SHIPTO_ONLINE_EMAIL',
                                      :city     => 'ECOM_SHIPTO_POSTAL_CITY',
                                      :address1 => 'ECOM_SHIPTO_POSTAL_STREET_LINE1',
                                      :address2 => 'ECOM_SHIPTO_POSTAL_STREET_LINE2',
                                      :zip      => 'ECOM_SHIPTO_POSTAL_POSTALCODE',
                                      :country  => 'ECOM_SHIPTO_POSTAL_COUNTRYCODE'

          mapping :layout,  :title => 'TITLE',
                            :bg_color => 'BGCOLOR',
                            :txt_color => 'TXTCOLOR',
                            :table_bg_color => 'TBLBGCOLOR',
                            :table_txt_color => 'TBLTXTCOLOR',
                            :button_bg_color => 'BUTTONBGCOLOR',
                            :button_txt_color => 'BUTTONTXTCOLOR',
                            :font_type => 'FONTTYPE',
                            :logo_name => 'LOGO',
                            :template_path => 'TP'

          mapping :description, 'COM'
          mapping :hidden_description, 'COMPLUS'
          mapping :additional_params, 'PARAMPLUS'
          
          # redirection
          mapping :redirect, :accepturl    => 'ACCEPTURL',
                             :declineurl   => 'DECLINEURL',
                             :cancelurl    => 'CANCELURL',
                             :exceptionurl => 'EXCEPTIONURL',
                             :backurl => 'BACKURL',
                             :homeurl => 'HOMEURL',
                             :catalogurl => 'CATALOGURL'


           # ALIAS management
           mapping :payment_alias, 'ALIAS'
           mapping :payment_alias_usage, 'ALIASUSAGE'

          def customer(mapping = {})
            add_field('OWNERTELNO', mapping[:phone])
            add_field('EMAIL', mapping[:email])
            add_field('CN', "#{mapping[:first_name]} #{mapping[:last_name]}")
          end

          def operation operation
            op = case operation
            when :authorization, :auth; 'RES'
            when :payment, :pay;        'SAL'
            else;                       operation
            end

            add_field('operation', op)
          end

          # return the fields
          def form_fields
            add_field('SHASign', outbound_message_signature)
            super
          end

        private

          def outbound_message_signature
            Ogone.outbound_message_signature(@fields)
          end

        end
      end
    end
  end
end