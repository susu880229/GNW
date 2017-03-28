/**
 * The Building class represents a physical building
 */
class Building 
{    

  ArrayList<BuildingUse> customizableUses;
  ArrayList<BuildingUse> permanentUses;

  /*
  * Sets the constants for flow. 
   * FLOW_DELAY_MULTIPLIER: A larger value means that particles will be generated at a slower rate, so less particles will exist.
   * MIN_DELAY_(TYPE): Sets the shortest amount of delay allowed for each type of building use. A higher value means that less particles 
   *                   will be allowed to enter or exit the building per second.
   */
  int FLOW_DELAY_MULTIPLIER = 20;
  int MIN_DELAY_MULTIPLIER = 5;
  float MIN_DELAY_OFFICE = 3 * MIN_DELAY_MULTIPLIER; 
  float MIN_DELAY_ART_CULTURE = 4 * MIN_DELAY_MULTIPLIER;
  float MIN_DELAY_EDUCATION = 3 * MIN_DELAY_MULTIPLIER;
  float MIN_DELAY_STUDENT_RES = 10 * MIN_DELAY_MULTIPLIER;
  float MIN_DELAY_TRANSIT = 3 * MIN_DELAY_MULTIPLIER;
  float MIN_DELAY_RESIDENT = 6 * MIN_DELAY_MULTIPLIER;
  float MIN_DELAY_RETAIL = 3 * MIN_DELAY_MULTIPLIER;
  float MIN_DELAY_LIGHT_IND = 3 * MIN_DELAY_MULTIPLIER;

  HotspotCoords buildingCoords;
  PVector[] bUDotCoords;
  String buildingName;
  int dotSize;
  int doorNodeId;
  float node_x;
  float node_y;
  Boolean isCustomizable;
  float particleGenRate;

  BuildingTooltip tooltip;
  Boolean showTooltip;
  int maxBuildingUses;

  /**
   * The Building constructor
   * @param name This is the id of the building
   * @param smallDot This sets if building use feedback dot is small size
   * @param doorNode The door id to the building.
   * @param buildingCoords This is the 4 coordinates of the building block
   * @param bUDotCoords This is a list of possible dot locations
   */
  Building (String name, Boolean smallDot, int doorNodeId, HotspotCoords buildingCoords, PVector[] bUDotCoords) 
  {
    buildingName = name;
    dotSize = (smallDot) ? 35 : 70;
    this.doorNodeId = doorNodeId;
    this.buildingCoords = buildingCoords;
    this.bUDotCoords = bUDotCoords;

    maxBuildingUses = (bUDotCoords!= null && bUDotCoords.length > 0) ? bUDotCoords.length : 0;
    customizableUses = new ArrayList<BuildingUse>();
    permanentUses = new ArrayList<BuildingUse>();
    isCustomizable = maxBuildingUses > 0;
    tooltip = (isCustomizable) ? new BuildingTooltip(buildingCoords, maxBuildingUses) :  null;
    particleGenRate = 0;
  }

  //rendering the block
  void render() 
  {
    drawPolygon();
    drawBuildingUses();
  }

  //highlights a lot when an icon is hovered over it
  void highlight()
  { 
    if (customizableUses.size() < maxBuildingUses)
    {
      switch(doorNodeId)    //use doorNodeId because Android does not support switch(String)
      {
      case 64:    //Lot5
        image(glowImage_lot5, 0, 0);
        break;
      case 17:    //Lot4
        image(glowImage_lot4, 0, 0);
        break;
      case 14:     //521
        image(glowImage_521, 0, 0);
        break;
      case 7:    //Lot7
        image(glowImage_lot7, 0, 0);
        break;
      case 12:    //515
        image(glowImage_515, 0, 0);
        break;

        //images starting from 1/4 of the width to save memory
      case 38:    //1933
        image(glowImage_1933, 1154, 0);
        break;
      case 44:    //701
        image(glowImage_701, 1154, 0);
        break;
      case 46:    //1980
        image(glowImage_1980, 1154, 0);
        break;

        //images starting from 1/2 of the width to save memory
      case 48:    //887
        image(glowImage_887, 2308, 0);
        break;
      case 50:    //901
        image(glowImage_901, 2308, 0);
        break;

        //images starting from 3/4 of the width to save memory
      case 55:    //Shaw
        image(glowImage_shaw, 3462, 0);
        break;
      case 59:    //Nature's Path
        image(glowImage_naturesPath, 3462, 0);
        break;
      }
    }
  }

  void drawPolygon() 
  {
    noFill();
    noStroke();
    beginShape();
    vertex(buildingCoords.topLeft.x, buildingCoords.topLeft.y);
    vertex(buildingCoords.topRight.x, buildingCoords.topRight.y);
    vertex(buildingCoords.bottomRight.x, buildingCoords.bottomRight.y);
    vertex(buildingCoords.bottomLeft.x, buildingCoords.bottomLeft.y);
    endShape(CLOSE);
  }

  void drawBuildingUses() 
  {
    if (!customizableUses.isEmpty())
      for (int i = 0; i < customizableUses.size(); i++) {
        BuildingUse bUse = customizableUses.get(i);

        color c = bUse.colorId;
        fill(c);
        ellipse(bUDotCoords[i].x, bUDotCoords[i].y, dotSize, dotSize);
      }
  }

  void drawTooltip()
  {
    if (maxBuildingUses > 0) 
    {
      tooltip.drawTooltip(customizableUses);
    }
  }

  //find the particle generation rate of each FlowRoute and add the FlowRoutes into an array
  ArrayList<FlowRoute> findParticleGenRate(ArrayList<FlowRoute> flowRoutes)
  {
    if (!customizableUses.isEmpty()) {
      findParticleGenRateHelper(customizableUses, flowRoutes);
    }

    if (!permanentUses.isEmpty()) {
      findParticleGenRateHelper(permanentUses, flowRoutes);
    }

    return flowRoutes;
  }

  ArrayList<FlowRoute> findParticleGenRateHelper( ArrayList<BuildingUse> buildingUses, ArrayList<FlowRoute> flowRoutes)
  {
    int delay = 0;
    ArrayList<Building> destBuildings = new ArrayList<Building>();
    ArrayList<UseFlow> time_flows = new ArrayList<UseFlow>();
    int from_numRepeatedUse = 1;
    int to_numRepeatedUse = 0;
    String[] useNames = {"none", "none", "none"};

    for (int count = 0; count < buildingUses.size(); count++)
    {
      useNames[count] = buildingUses.get(count).name;
    }

    for (int i = 0; i < buildingUses.size(); i++) {

      BuildingUse FromUse = buildingUses.get(i);

      //find out if the building has repeated uses, and give each use a "repeated use index" to differentiate them from each other
      from_numRepeatedUse = findRepeatedUseIndex(i, FromUse.name, useNames);

      //for the time selected, find all applicable flow logic and delay values
      if (cur_time >= 0 && cur_time <= 4)
      {
        time_flows = findFlows(cur_time);
        for (UseFlow flow : time_flows)
        {
          //if the building use currently being examined has an outflow at the current time, find all buildings that it should be linked to, and get their doorNodeIds.
          if (flow.from_use.equals(FromUse.name))
          {
            destBuildings = findBuildings(flow.to_use);
            delay = flow.delay * FLOW_DELAY_MULTIPLIER;
            if (destBuildings != null && !destBuildings.isEmpty()) 
            { 
              for (int j = 0; j < destBuildings.size(); j++) 
              {
                int destDoorNodeId = destBuildings.get(j).doorNodeId;

                //if the destination is not the current building, find the "repeated use index" of the destination use, and create the FlowPath using the parameters found
                if (destDoorNodeId != this.doorNodeId)
                {  
                  to_numRepeatedUse = 1;
                  for (int j1 = 0; j1 < j; j1++)
                  {
                    if (destDoorNodeId == destBuildings.get(j1).doorNodeId) 
                    {
                      to_numRepeatedUse++;
                    }
                  }

                  FlowRoute fA = new FlowRoute (this.doorNodeId, destDoorNodeId, flow.delay, delay, flow.from_use, flow.to_use, from_numRepeatedUse, to_numRepeatedUse);

                  //if the flowRoutes array is empty (i.e. it is the first route), add it into the array
                  if (flowRoutes.isEmpty())
                  {
                    flowRoutes.add(fA);
                  } else
                  {
                    //if the flow route exists, update the delay of the route. Else, add the flow route into the array.
                    Boolean flowExists = false;
                    for (int flowCount = 0; flowCount < flowRoutes.size(); flowCount++)
                    {
                      FlowRoute curFlowRoute = flowRoutes.get(flowCount);
                      if (fA.initial_nodeID == curFlowRoute.initial_nodeID && fA.from_buildingUse == curFlowRoute.from_buildingUse && fA.from_repeatUseIndex == curFlowRoute.from_repeatUseIndex &&
                        fA.dest_nodeID == curFlowRoute.dest_nodeID && fA.to_buildingUse == curFlowRoute.to_buildingUse && fA.to_repeatUseIndex == curFlowRoute.to_repeatUseIndex)
                      {
                        flowRoutes.get(flowCount).delay = delay;
                        flowExists = true;

                        //if the countdown to next particle generation is longer than the new delay, set the countdown to the new delay
                        if (curFlowRoute.timeToNextParticleGen > delay)
                        {
                          flowRoutes.get(flowCount).timeToNextParticleGen = delay;
                        }
                        break;
                      }
                    }
                    if (!flowExists)
                    {
                      flowRoutes.add(fA);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return flowRoutes;
  }


  int findRepeatedUseIndex(int useIndex, String FromUseName, String[] useNames)
  {
    //if the building use being examined is the second use of the building, and if the first use has the same name, index = 2
    if (useIndex == 1 && FromUseName.equals(useNames[0]))
    {
      return 2;
    }

    //if the building use being examined is the third use of the building, and if the first two uses have the same name, index = 3
    else if (useIndex == 2 && FromUseName.equals(useNames[0]) && FromUseName.equals(useNames[1]))
    {
      return 3;
    }

    //or else, if the building use being examined is the third use of the building, and if either the first or second use has the same name, index = 2
    else if (useIndex == 2 && (FromUseName.equals(useNames[0]) || FromUseName.equals(useNames[1])))
    {
      return 2;
    } 
    
    else
    {
      return 1;
    }
  }

  /*
  * Checks if the combined in and out flows from a particular use in a building is less than a minimum (shortest) delay limit.
   * If it the actual delay is lesser, cap the delay to the minimum allowable limit by splitting it among the flows that are affected.
   * The result is similar to having a maximum 'number' of particles that can enter or leave a use at any one time.
   */
  ArrayList<FlowRoute> checkDelayLimit(ArrayList<FlowRoute> flowRoutes, boolean isIn, boolean isOut)
  {
    if (!customizableUses.isEmpty()) 
    {
      checkDelayLimitHelper(customizableUses, flowRoutes, isIn, isOut);
    }

    if (!permanentUses.isEmpty()) 
    {
      checkDelayLimitHelper(permanentUses, flowRoutes, isIn, isOut);
    }

    return(flowRoutes);
  }

  ArrayList<FlowRoute> checkDelayLimitHelper(ArrayList<BuildingUse> buildingUses, ArrayList<FlowRoute> flowRoutes, boolean isIn, boolean isOut)
  {   
    for (int i = 0; i < buildingUses.size(); i++) 
    {
      ArrayList<FlowRoute> flowList = new ArrayList<FlowRoute>();
      int[] flowRouteIndex = new int[flowRoutes.size()];
      int flowIndexCount = 0;
      int totalDelayUnits = 0;
      int repeatUseIndex = 1;
      boolean flowMatchCondition;

      BuildingUse curUse = buildingUses.get(i);
      float minDelay = findMinDelay(curUse.name);

      //find the repeat index for the particular use
      if (i == 1 && buildingUses.get(0).name.equals(curUse.name))
      {
        repeatUseIndex = 2;
      } else if (i == 2)
      {
        if ((buildingUses.get(0).name.equals(curUse.name) && !buildingUses.get(1).name.equals(curUse.name)) ||
          (!buildingUses.get(0).name.equals(curUse.name) && buildingUses.get(1).name.equals(curUse.name)))
        {
          repeatUseIndex = 2;
        } else if (buildingUses.get(0).name.equals(curUse.name) && buildingUses.get(1).name.equals(curUse.name))
        {
          repeatUseIndex = 3;
        }
      }

      //finds all the flows that are generated from/to this particular building and use, and add them into array flowList
      for (int j = 0; j < flowRoutes.size(); j++)
      {
        FlowRoute curFlowRoute = flowRoutes.get(j);
        flowMatchCondition = false;

        if (isOut && curFlowRoute.from_buildingUse.equals(curUse.name) && curFlowRoute.initial_nodeID == doorNodeId && curFlowRoute.from_repeatUseIndex == repeatUseIndex)
        {
          flowMatchCondition = true;
        } else if (isIn && curFlowRoute.to_buildingUse.equals(curUse.name) && curFlowRoute.dest_nodeID == doorNodeId && curFlowRoute.to_repeatUseIndex == repeatUseIndex)
        {
          flowMatchCondition = true;
        }

        if (flowMatchCondition == true)
        {
          flowList.add(curFlowRoute);
          flowRouteIndex[flowIndexCount] = j;
          flowIndexCount++;

          //calculate the total number of delay units, which is the delay number specified for each flow in flow matrix.txt
          totalDelayUnits += curFlowRoute.numDelayUnit;
        }
      }

      if (flowIndexCount != 0)
      {
        //perform calculations to see if actual delay is less than minimum allowed for that particular building and use
        float numFlows_squared = pow(flowIndexCount-1, 2);
        float actualDelay = (totalDelayUnits * FLOW_DELAY_MULTIPLIER) / numFlows_squared;

        //if delay is less than minimum allowed, calculate the delay per unit to achieve minimum delay
        float allowedUnitDelay;
        if (actualDelay < minDelay)
        {
          allowedUnitDelay = (minDelay * numFlows_squared) / totalDelayUnits;

          //update flowRoutes with the new delay values and countdown to next particle generation
          for (int k = 0; k < flowList.size(); k++)
          {
            FlowRoute curFlowRoute = flowRoutes.get(flowRouteIndex[k]);
            if ((allowedUnitDelay * curFlowRoute.numDelayUnit)  > curFlowRoute.delay)
            {
              flowRoutes.get(flowRouteIndex[k]).delay = (int)(curFlowRoute.numDelayUnit * allowedUnitDelay);
              flowRoutes.get(flowRouteIndex[k]).timeToNextParticleGen = (int)random(0, curFlowRoute.delay);
            }
          }
        }
      }
    }
    return(flowRoutes);
  }

  float findMinDelay(String use_name)
  {
    if (use_name.equals("Office"))
    {
      return MIN_DELAY_OFFICE;
    } else if (use_name.equals("Art and Culture"))
    {
      return MIN_DELAY_ART_CULTURE;
    } else if (use_name.equals("Education"))
    {
      return MIN_DELAY_EDUCATION;
    } else if (use_name.equals("Student Resident"))
    {
      return MIN_DELAY_STUDENT_RES;
    } else if (use_name.equals("Transit"))
    {
      return MIN_DELAY_TRANSIT;
    } else if (use_name.equals("Resident"))
    {
      return MIN_DELAY_RESIDENT;
    } else if (use_name.equals("Retail"))
    {
      return MIN_DELAY_RETAIL;
    } else if (use_name.equals("Light Industry"))
    {
      return MIN_DELAY_LIGHT_IND;
    } else 
    {
      return -1;
    }
  }

  /**
   * Returns list of buildings for specific building use
   * @param buName is the name of building use
   */
  ArrayList<Building> findBuildings(String UseName)
  {
    ArrayList<Building> buildings = (ArrayList<Building>) use_buildings.get(UseName);
    return buildings;
  }

  ArrayList<UseFlow> findFlows(int timeID)
  {    
    ArrayList<UseFlow> flows = (ArrayList<UseFlow>) use_flows.get(timeID);
    return flows;
  }

  /**
   * Adds building use to the building
   * @param buildingUse is the building use object to be added
   */
  void addBuildingUse(BuildingUse buildingUse) throws Exception
  {
    if (customizableUses.size() < maxBuildingUses) {
      customizableUses.add(buildingUse);      
      use_buildings.get(buildingUse.name).add(this);
    } else {
      throw new Exception ("too many building uses");
    }
  }

  void addPermanentUse(BuildingUse buildingUse) 
  {
    permanentUses.add(buildingUse);      
    use_buildings.get(buildingUse.name).add(this);
  }

  void deleteBuildingUse(ArrayList<Particle> particles, ArrayList<FlowRoute> flowRoutes) throws Exception
  {
    String bUtoDelete = tooltip.selectBuildingUse(customizableUses);
    int repeatedUseIndex = 0;

    for (int useCount = 0; useCount < customizableUses.size(); useCount++)
    {
      if (customizableUses.get(useCount).name.equals(bUtoDelete))
      {
        repeatedUseIndex++;
      }
    }

    for (int i = 0; i < customizableUses.size(); i++) {
      String bUName = customizableUses.get(i).name;      
      if (bUtoDelete.equals(bUName)) {
        customizableUses.remove(i);

        //remove the particles associated with the removed building use
        for (int j = particles.size() - 1; j >= 0; j--)
        {
          Particle curParticle = particles.get(j);
          if (curParticle.initial_nodeID == doorNodeId &&  curParticle.from_buildingUse.equals(bUName) || curParticle.dest_nodeID == doorNodeId && curParticle.to_buildingUse.equals(bUName))
          {
            particles.remove(j);
          }
        }

        //remove the flow routes associated with the removed building use
        for (int k = flowRoutes.size() - 1; k >= 0; k--)
        {
          FlowRoute curFlowRoute = flowRoutes.get(k);
          if (curFlowRoute.initial_nodeID == doorNodeId && curFlowRoute.from_buildingUse.equals(bUName) && curFlowRoute.from_repeatUseIndex == repeatedUseIndex ||
            curFlowRoute.dest_nodeID == doorNodeId && curFlowRoute.to_buildingUse.equals(bUName) && curFlowRoute.to_repeatUseIndex == repeatedUseIndex)
          {
            flowRoutes.remove(k);
          }
        }

        ArrayList<Building> bUBuildings = (ArrayList<Building>)use_buildings.get(bUtoDelete);        
        bUBuildings.remove(this);
      }
    }
    throw new Exception("Can't delete building use");
  }
}