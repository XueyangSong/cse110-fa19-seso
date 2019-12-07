![WechatIMG1164](./WechatIMG1164.jpeg)















<table style="margin-left: auto; margin-right: auto">
  <tr>
    <td>Project Manager: Jamie Song<br/>Business Analyst: Jiahe Liu<br/>Quality Assurance Lead: Yuechen Liu<br/>Database Specialist: Aileen Wu<br/>User Interface Specialist: Guanyi Lu</td>
    <td>Algorithm Specialist: Mingyu Chen<br/>Algorithm Specialist: Yiran Shao<br/>Software Architect: Yuxin Li<br/>Senior System Analyst: Yixing Wang<br/>Software Development Lead: Zhen Duan</td>
  </tr>
</table>
















# Introduction

With the searching function and rating system, the informative profile page of every users, and the organized events list, Tuta is really an app which provides a solution for an efficient, reliable and convenient tutor-student matching. We believe this app will make a great contribution to the balance between the teaching resources demanded by students and that offered by UCSD.



# Login Credentials

For testing purposes, we have created two accounts for ease of understanding functionality and relationship between users. The tutor is the one sending postcards as "tutors", and the student is the one sending postcards as "students", though both accounts could act as "tutors" and "students".

Tutor Account:<br/>__Username__: yul094@ucsd.edu  __Password__: 12345678

Student Account:<br/>__Username__: xus023@ucsd.edu  __Password__: 12345678





# Requirements

This application must be run on an IOS platform.

The User must have a valid UCSD email address.

The User must have internet connection while using the application.

The User must have an Iphone 11 or Iphone 11 Pro Max.





# Installation Instruction

1. Obtain a Mac computer with XCode installed.
2. Download our zip file containing TUTA from the Github Link: https://github.com/XueyangSong/cse110-fa19-seso.git.
3. Unzip the file.
4. Open TUTA.xcodeproj in XCode.
5. Attach device (iPhone) to computer. Select "Trust" if asked to trust the device.
6. On the top-left corner, select the device connected to Mac
7. Press the "Play" button in XCode to build and run the program.





# How to Run

1. After installing the application on the device, navigate to the page that contains the TUTA logo and app name.
2. Press the TUTA logo to run the application.





# Known Bugs/Issues

1. After a user deletes his own postcard, the postcard will not immediately disappear on the search board. The user has to refresh the search board to make the postcard disappear.
2. If a currently displaying postcard on a user’s search board gets deleted, the user could still see it and open the postcard to request the owner of the deleted postcard.
3. If a user requests another user for a tutor session, this user could not see the other user’s profile by clicking the event in “My Event List” page.
4. When a user searches for a course without any postcards related to it, the search board will not display anything, which means there will not be any message notifying the user that the search list is empty. 
5. The user cannot delete anything in the “Courses Taken” field in his profile.
6. After a user changes his password, if he re-launches the application he could still get automatically logged in without entering his new password.
7. If a user enters another user’s email in the “Change Password” page, the owner of the email will receive an email regarding changing password.
8. When a user has an unstable internet connection, any task on the application could cause the whole application to crash.
9. When a user adds a phone number in his profile, the application doesn’t verify the validity of the phone number entered.
10. The user won’t get notification if the target user deletes the request they sent.
11. The trigger area of the “+” tab on tab bar is different from what it looks like. The position it locates on the screen is slightly above where it actually is.
12. When the user tabs the search button or the segment control to search for postcards, it takes 1 to 2 seconds to display the postcards on screen.





# Technical Support

| Duan Zhen   | zhen.duan.nfd@gmail.com | Tech Lead            |
| :---------- | ----------------------- | -------------------- |
| Jiahe Liu   | jil061@ucsd.edu         | Business Analyst     |
| Jamie Song  | xus023@ucsd.edu         | Project Manager      |
| Mingyu Chen | mic215@ucsd.edu         | Algorithm Specialist |