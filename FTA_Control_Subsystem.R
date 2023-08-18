# This script presents the Fault Tree Analysis of the subsystem control for a 
# Dynamic Positioning System class 2.
# M. V Clavijo, A. M. Schleder, E. L. Droguett, and M. R. Martins, “RAM analysis
# of dynamic positioning system: An approach taking into account uncertainties 
# and criticality equipment ratings” Part O J. Risk Reliab., 2021, 
# doi: 10.1177/1748006X211051805.

# 0. Import required library
library(FaultTree)

# 1. Time mission definition and probability of failure of subsystem components
T_mission = 8760
wind      = pexp(T_mission, 0.0000515)
VRS       = pexp(T_mission, 0.0000113)
gyro      = pexp(T_mission, 0.0000333)
hydro     = pexp(T_mission, 0.0000285)
DGPS      = pexp(T_mission, 0.0000102)
UPS       = pexp(T_mission, 0.00000895)
IJS       = pexp(T_mission, 0.0000174)
computer  = pexp(T_mission, 0.0000174)

# 2. Design of Fault Tree
control_subsys <- ftree.make(type="or", name="Total control subsystem failure - DP2")
## 2.1 Main causes for top event
control_subsys <- addLogic(control_subsys, at = 1, type = 'and', name = 'Loss of controllers')
control_subsys <- addLogic(control_subsys, at = 1, type = 'and', name = 'Failure of critical UPS')
### 2.2 Loss of controllers
control_subsys <- addLogic(control_subsys, at = 2, type = 'or', name = 'IJS unavailable')
control_subsys <- addLogic(control_subsys, at = 2, type = 'or', name = 'Control computers unavailable')
### 2.2 Failure of critical UPS
control_subsys <- addProbability(control_subsys, at = 3, prob = UPS, name = "UPS B fails")
control_subsys <- addProbability(control_subsys, at = 3, prob = UPS, name = "UPS C fails")
## 2.3 IJS unavailable
control_subsys <- addProbability(control_subsys, at = 4, prob = DGPS, name="DGPS 2 fails")
control_subsys <- addProbability(control_subsys, at = 4, prob = IJS, name="IJS fails")
control_subsys <- addDuplicate(control_subsys, at = 4, dup_id = 7)
control_subsys <- addLogic(control_subsys, at = 4, type = 'or', name = 'Failure of sensors')
control_subsys <- addProbability(control_subsys, at = 11, prob = wind, name = "Wind 3 fails")
control_subsys <- addProbability(control_subsys, at = 11, prob = VRS, name = "VRS 1 fails")
control_subsys <- addLogic(control_subsys, at = 11, type = 'and', name = 'Failure of Gyros')
control_subsys <- addProbability(control_subsys, at = 14, prob = gyro, name = "Gyro 2 fails")
control_subsys <- addProbability(control_subsys, at = 14, prob = gyro, name = "Gyro 3 fails")
### 2.4 Control computers unavailable
control_subsys <- addLogic(control_subsys, at = 5, type = 'and', name = 'Failure of control computers')
control_subsys <- addLogic(control_subsys, at = 5, type = 'or', name = 'Failure of sensors')
control_subsys <- addLogic(control_subsys, at = 5, type = 'and', name = 'Failure of PRSs')
### 2.4 Failure of control computers
control_subsys <- addProbability(control_subsys, at = 17, prob = computer, name = "Control computer 1 fails")
control_subsys <- addProbability(control_subsys, at = 17, prob = computer, name = "Control computer 2 fails")
control_subsys <- addProbability(control_subsys, at = 17, prob = computer, name = "Control computer 3 fails")
### 2.4 Failure of sensors
control_subsys <- addLogic(control_subsys, at = 18, type = 'and', name = 'Failure of VRSs')
control_subsys <- addLogic(control_subsys, at = 18, type = 'and', name = 'Failure of sensors')
control_subsys <- addLogic(control_subsys, at = 18, type = 'and', name = 'Failure of Gyros')
control_subsys <- addDuplicate(control_subsys, at = 23, dup_id = 13)
control_subsys <- addProbability(control_subsys, at = 23, prob = VRS, name = "VRS 2 fails")
control_subsys <- addProbability(control_subsys, at = 23, prob = VRS, name = "VRS 3 fails")
control_subsys <- addProbability(control_subsys, at = 24, prob = wind, name="Wind 1 fails")
control_subsys <- addProbability(control_subsys, at = 24, prob = wind, name="Wind 2 fails")
control_subsys <- addDuplicate(control_subsys, at = 24, dup_id = 12)
control_subsys <- addProbability(control_subsys, at = 25, prob = gyro, name="Gyro 1 fails")
control_subsys <- addDuplicate(control_subsys, at = 25, dup_id = 15)
control_subsys <- addDuplicate(control_subsys, at = 25, dup_id = 16)
### 2.4 Failure of PRSs
control_subsys <- addProbability(control_subsys, at = 19, prob = hydro, name="Hydro 1 fails")
control_subsys <- addProbability(control_subsys, at = 19, prob = hydro, name="Hydro 2 fails")
control_subsys <- addProbability(control_subsys, at = 19, prob = DGPS, name="DGPS 1 fails")
control_subsys <- addDuplicate(control_subsys, at = 19, dup_id = 8)

# 3. Quantification of fault tree
control_subsys <- ftree.calc(control_subsys, use.bdd = TRUE)

# 4. Visualization of fault tree
ftree2html(control_subsys, write_file=TRUE)
browseURL("control_subsys.html")

