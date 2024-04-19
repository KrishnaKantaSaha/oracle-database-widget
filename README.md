This project is about a record-keeping database solution for Widget Ltd. for modernization of their currently manual-filing system to Oracle DB system. 
Below are the schemas:
1. WIDGET 		: Main schema containing all the objects
2. WIDGET_RO 	: This no-object schema/user has read-only access on WIDGET objects
3. WIDGET_RW 	: This no-object schema/user has read-write access on WIDGET objects

The deployment will happen through RLM and Jenkins build
Use file 'deployment_steps.ctl' to deploy the widget's database objects
