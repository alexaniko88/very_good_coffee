# VERY GOOD COFFEE
A simple app where you can see the random coffee image each time the app is being reloaded or the next button is being pressed.
Basically you can see two buttons the screen, first to force app reload and the second for get the next random coffee image.
Also, whenever user likes, the coffee image can be stored locally as a favorite coffee. This favorite coffee is accessible 
by tapping the second tab called **Favorite** or simply reloading the app. While the favorite is marked, user can always see the 
image even if the services are failing or is offline. Also once unmarked, the next random photo will be returned. 
If something is not working or the services are answering with delay, **save to favorite** icon will not be visible.
Reload and Next buttons are always available.

# TESTS

All the app is tested with **Unit** and **Widget Tests**.
App was built/compiled and executed in the real **Android OnePlus 7T** device and also in iOS Simulator.

In this project, the golden tests are used, so you can find the captures under test/widget/golden.

Also to easily check the test coverage, the **runTestCoverage.sh** has been added, so simply run it in your terminal 
and check the coverage. The last time run gave the 92.7% of teh coverage.

# EXAMPLES

![very_goo_coffe_example](https://user-images.githubusercontent.com/40612984/208268780-966ef930-7c8d-4430-b1f0-72bebf5e1ed1.gif)
