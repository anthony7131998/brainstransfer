#Brain Image Transfer
Sends zipped brain images, PET and MRI, from shared driver to respective folders in NACCserver

#Getting Started
Before running this script, look over the file "examplelogininfo" to review the variables values needed to replace. This file will contain all the necessary environmental variables for a smooth image transfer. 

#Brain_Image_Transfer.sh
Securely copies the brain images to a remote directory whose IP is accepted by NACC. Accesses this intermediate remote directory to upload the copies onto respective directories of NACC server. 

#examplelogininfo.sh
Contains the credentials needed to ssh and scp files. After changing the environmental variable values, rename the file as "logininfo.bash." Make sure a local copy of the brain image scans are available on your desktop. 

The local copy should have a clear indication between the MRI and APET locations,e.g. one directroy down. There should be no subfolders within these two locations, as only .zip files will be transferred to NACC server. 
