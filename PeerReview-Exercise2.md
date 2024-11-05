# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* [your name here] 
* *email:* [your @ucdavis.edu email address here]

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera does not center to wherever the ball goes. The cross does not stay with the ball. The cross is centered in the camera as it should be, but the ball and cross do not match. 

___
### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera is moving at a constant speed as it should, however, the ball does not move within a the given box. It moves according to the keyboard inputs but then moves back to the center. The correct working state should allow the ball to move within the box without reverting the ball back to the center. The box is not drawn to show the bounds of the autoscroll

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera follows the ball at a certain lag correctly, and after the ball stops moving the camera correctly centers to the ball's location again. The ball stays within a certain leash distance and is ensured not to go farther than that. A 5 x 5 cross is correctly drawn at the center of the camera.
___
### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera correctly leads the ball's movement and its direction at a certain lead spead. The camera correctly recenters back to the ball's location after the ball stops moving. There is a small amount of wait time before the recentering happens as specified in the directions. 
___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
No boxes are drawn to indicate the push_zone and speedup_zone. The ball does not seem to be following any pattern, there is no area where the camera does not move as it should, and the general functionality of the stage is missing.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the dotnet style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

Student did a good job following most of the GD style guide, there were only a few rules that were broken.

This line is [too long and should use double indents and be continued on multiple lines](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/lock_lerp.gd#L30)

The 4 variables starting on this line are all private variables used only within the class for calculating the logic, [all private variables should precede with an underscore](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L9C1-L12C83) according to GD naming conventions

[Functions should be wrapped with 2 empty lines](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L72)

#### Style Guide Exemplars ####

Did a good job following [the correct order of the variables](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L4C1-L12C83)

Good job using correct formatting for [one liner if/else statement](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/push_zone.gd#L60)
___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices (Unity coding conventions from the StyleGuides document) then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

[Using variables for constants like 2.5](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/lock_lerp.gd#L59) will help someone reading the code understand the value, and will make it easier in case the value needs to be tweaked.

[Remove any unused commented lines of code](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/position_lock.gd#L12)

There should be [no export variables for the position lock stage](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/position_lock.gd#L4) as specified in the instructions


#### Best Practices Exemplars ####

The student did a great job [commenting all significant chunks of code with an explanation of what those lines of code are doing.](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L42) This really helped understand the flow of the logic. The permalink is one example of where they did this, but the student was very consistent with commenting throughout all their files.
