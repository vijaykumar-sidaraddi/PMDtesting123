public class PMDTest {

    public Account account { get; private set; }
    public integer countContact{get; set;}

    public PMDTest() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        account = (id == null) ? new Account() : 
            [SELECT Name, Phone, Industry FROM Account WHERE Id = :id];
    } 

    public PageReference save() {
        try {  
                 
                account.BillingCity ='TestCity';
                // upsert(account);
        /* Account newAccount = new Account (name = AcName,
            BillingCity ='TestCity',
            BillingCountry ='TestCountry',
            BillingStreet ='TestStreet',
            BillingPostalCode ='t3stcd3'
            );
            */
            insert account;
            
             //Bad Example Start         
            for ( integer cnt=0; cnt < countContact; cnt++) {
                
                List<Contact> contacts = [select id, firstname, lastname, email
                        from Contact where accountId = :a.Id];
                
                Contact NewContact = new Contact (
                FirstName = 'xyzFirst1111111111111115 Bad'+cnt + ' ',
                LastName = 'XyZLast Bad'+cnt,
                //line changed - waveoc
                AccountId = '0014B00000QqGxO',
                Email = 'xyzmail@mail.com'
                );
                
                
                
                //line added - waveoc
                insert newContact;
            }
            
         //Bad Example End
        //Good Example Start
         List<Contact> newContacts = new List<Contact>(); 
          for ( integer cnt=0; cnt < countContact; cnt++) {
                
                Contact NewContact = new Contact (
                FirstName = 'xyzFirst Good'+cnt + ' ',
                LastName = 'XyZLast Good'+cnt,
                //line changed - waveoc
                AccountId = account.Id,
                Email = 'xyzmail@mail.com'
                );
                
                //line added - waveoc
            newContacts.add(NewContact);
            }
            insert newContacts;
       //Good Example End
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        //  After successful Save, navigate to the default view page
        PageReference redirectSuccess = new ApexPages.StandardController(Account).view();
        return (redirectSuccess);
    }
}