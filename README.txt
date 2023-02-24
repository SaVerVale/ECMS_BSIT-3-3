Evacuation Center Management System 

Authors: Valenciano, Agbay, Gimeno, Sacatani

Evacuation Management Database System will provide a systematic way to manage and
organize evacuees, the facilities, and relief operations to make it easier for the officials to
interact with it. The officials will be able to prevent overpopulation by knowing the
headcounts due to the evacuees' information being recorded. It will also help them to track
evacuees who needs special care such as the elderly aged 60 years old and above, people
with comorbidities, and the pregnant women. Inventory and distribution of essential goods
will be much easier to manage using this system. The Evacuation Management Database
System will help the officials to provide accommodation and services to all the evacuees
and reduce management issues that were mentioned above.

Instructions:
1. Clone/export this to C:\xampp\htdocs and to a folder of your choice.
2. Create new schema in MySQL and name it "evac_management_system".
3. Server > Data Import > Import from Self-Contained file > Select Dump20230223.sql(from assets) 
   > Default Target Schema "evac_management_system" > Start Import.
4. Start XAMPP > Start MySQL (PID 5148, Port 3306) > Start Apache (PID 4544, Port(s) 80, 443).
5. Run in browser(better in Chrome, not in Firefox) http://localhost/ and name of folder.
6. You have the system running!

Notes:
  1. session_login.php credentials are default as admin admin. You can add users from user table in mysql.
    (Sign up form is not intended to be created for we only target the admin as the user)
  2. Errors at session_login are designed for admin. Please edit it in your own will.
  3. Only add_area.php has error validation in creation. Other creation forms will transfer you to a blank 
    page when you submit an empty form.
  4. Edit forms are all working without crash except in center form where you might need to look again at
    the modal to see the error message.
  5. Sort functions are working but display will reset back in first option. (Example, if you sort evacuees by age, 
    then it will sort the data by age but the display(in the box) will revert display as Evacuation Status).
  6. Use it in Chrome! Other browsers might not display it as well as in Chrome. Example, it has some 
    overflow in Firefox. Suspected bug is in the css file(rem as unit).