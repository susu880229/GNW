/**
 * The Building class represents a physical building
 */
class Building 
{    

  ArrayList<BuildingUse> customizableUses;
  ArrayList<BuildingUse> permanentUses;

  int FLOW_DELAY_MULTIPLIER = 100;
  int MIN_DELAY_MULTIPLIER = 5;
  float MIN_DELAY_BUSINESS = 3 * MIN_DELAY_MULTIPLIER; 
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
      
      //find the index of repeated from_use
      if (i == 1 && FromUse.name.equals(useNames[0]))
      {
        from_numRepeatedUse = 2;
      }
      else if (i == 2 && FromUse.name.equals(useNames[0]) && FromUse.name.equals(useNames[1]))
      {
        from_numRepeatedUse = 3;
      }
      else if (i == 2 && (FromUse.name.equals(useNames[0]) || FromUse.name.equals(useNames[1])))
      {
        from_numRepeatedUse = 2;
      }
      
      if (cur_time >= 0 || cur_time < 4)
      {
        time_flows = findFlows(cur_time);
        for (UseFlow flow : time_flows)
        {
          if (flow.from_use.equals(FromUse.name))
          {
            destBuildings = findBuildings(flow.to_use);
            delay = (int)(pow(2, flow.delay - 1)) * FLOW_DELAY_MULTIPLIER;
            if (destBuildings != null && !destBuildings.isEmpty()) 
            { 
              for (int j = 0; j < destBuildings.size(); j++) 
              {
                int destDoorNodeId = destBuildings.get(j).doorNodeId;
                if (destDoorNodeId != this.doorNodeId)
                {
                  
                  //find the index of repeated to_use
                  int countSameUse = 0;
                  for (int j1 = 0; j1 < j; j1++)
                  {
                    if (destDoorNodeId == destBuildings.get(j1).doorNodeId) 
                    {
                      countSameUse++;
                    }
                  }
                  to_numRepeatedUse = countSameUse + 1;
                  
                  FlowRoute fA = new FlowRoute (this.doorNodeId, destDoorNodeId, flow.delay, delay, flow.from_use, flow.to_use, from_numRepeatedUse, to_numRepeatedUse);
                  flowRoutes.add(fA);
                  if (flowRoutes.isEmpty())
                  {
                    flowRoutes.add(fA);
                  }
                  else
                  {
                  //if the flow route exists, update the delay. Else, add it into the array.
                    Boolean flowExists = false;
                    for (int flowCount = 0; flowCount < flowRoutes.size(); flowCount++)
                    {
                      FlowRoute curFlowRoute = flowRoutes.get(flowCount);
                      if (fA.initial_nodeID == curFlowRoute.initial_nodeID && fA.from_buildingUse == curFlowRoute.from_buildingUse && fA.from_repeatUseIndex == curFlowRoute.from_repeatUseIndex &&
                          fA.dest_nodeID == curFlowRoute.dest_nodeID && fA.to_buildingUse == curFlowRoute.to_buildingUse && fA.to_repeatUseIndex == curFlowRoute.to_repeatUseIndex)
                      {
                        flowRoutes.get(flowCount).delay = delay;
                        flowExists = true;
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
  
  /*
  * Checks if the combined in and out flows from a particular use in a building is less than a minimum delay limit.
  * If it is lesser, split the minimum delay limit among the flows that are affected.
  * The result is equivalent to having a maximum 'number' of particles that can enter or leave a use at any one time.
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
      boolean flowMatchCondition;
    
      BuildingUse curUse = buildingUses.get(i);
      float minDelay = findMinDelay(curUse.name);
      
      //finds all the flows that are generated from/to this particular building and use
      for (int j = 0 ; j < flowRoutes.size(); j++)
      {
        FlowRoute curFlowRoute = flowRoutes.get(j);
        flowMatchCondition = false;
        
        if (isOut && curFlowRoute.from_buildingUse.equals(curUse.name) && curFlowRoute.initial_nodeID == doorNodeId)
        {
          flowMatchCondition = true;
        }
        else if (isIn && curFlowRoute.to_buildingUse.equals(curUse.name) && curFlowRoute.dest_nodeID == doorNodeId)
        {
          flowMatchCondition = true;
        }
        
        if (flowMatchCondition == true)
        {
          flowList.add(curFlowRoute);
          flowRouteIndex[flowIndexCount] = j;
          flowIndexCount++;
          
          totalDelayUnits += curFlowRoute.numDelayUnit;
        }
      }
      
      if (flowIndexCount != 0)
      {
        //perform calculations to see if delay is less than min allowed for that particular building and use
        int numRepeatUse = 0;
        for(int bUseCount = 0; bUseCount < buildingUses.size(); bUseCount++)
        {
          if (buildingUses.get(bUseCount) == curUse)
          {
            numRepeatUse++;
          }
        }
        float numFlows_squared = pow(flowIndexCount-1, 2);
        float actualDelay = numRepeatUse * ((totalDelayUnits * FLOW_DELAY_MULTIPLIER) / numFlows_squared);
        
        //if delay is less than min allowed, calculate the delay per unit to achieve min delay
        float allowedUnitDelay;
        if (actualDelay < minDelay)
        {
          allowedUnitDelay = (minDelay * numFlows_squared) / totalDelayUnits;
          
          //update flowRoutes with the new delay values
          for (int k = 0; k < flowList.size(); k++)
          {
            if (allowedUnitDelay > flowRoutes.get(flowRouteIndex[k]).delay)
            {
              flowRoutes.get(flowRouteIndex[k]).delay = (int)(flowRoutes.get(flowRouteIndex[k]).numDelayUnit * allowedUnitDelay);
              flowRoutes.get(flowRouteIndex[k]).timeToNextParticleGen = (int)random(0, flowRoutes.get(flowRouteIndex[k]).delay);
            }
          }
        }
      }
    }
    return(flowRoutes);
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

  ArrayList<Particle> deleteBuildingUse(ArrayList<Particle> particles, ArrayList<FlowRoute> flowRoutes) throws Exception
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

        return particles;
      }
    }
    throw new Exception("Can't delete building use");
  }
  
  float findMinDelay(String use_name)
  {
    if (use_name.equals("Business"))
    {
      return MIN_DELAY_BUSINESS;
    }
    else if (use_name.equals("Art and Culture"))
    {
      return MIN_DELAY_ART_CULTURE;
    }
    else if (use_name.equals("Education"))
    {
      return MIN_DELAY_EDUCATION;
    }
    else if (use_name.equals("Student Resident"))
    {
      return MIN_DELAY_STUDENT_RES;
    }
    else if (use_name.equals("Transit"))
    {
      return MIN_DELAY_TRANSIT;
    }
    else if (use_name.equals("Resident"))
    {
      return MIN_DELAY_RESIDENT;
    }
    else if (use_name.equals("Retail"))
    {
      return MIN_DELAY_RETAIL;
    }
    else if (use_name.equals("Light Industry"))
    {
      return MIN_DELAY_LIGHT_IND;
    }
    else 
    {
      return 100*MIN_DELAY_MULTIPLIER;
    }
  }
}