class BuildingUse
{
  String name;
  String imgSrc;
  color colorId;
  //int use_class;
  
    BuildingUse(String name, String imgSrc, color colorId)
    {
      this.name = name;
      this.imgSrc = imgSrc;
      this.colorId = colorId;
    }
    
    int class_decide()
    {
      int use_class = -1;
      if (cur_time == "morning")
      {
        if (imgSrc == "restaurant.png")
        {
          use_class = 2;
        } 
        else if (imgSrc == "resident.png" || imgSrc == "transit.png")
        {
          use_class = 3;
        } 
        else if (imgSrc == "office.png" || imgSrc == "school.png")
        {
          use_class = 1;
        }
     
        else if (imgSrc == "recreation.png")
        {
          use_class = -1;
        }
    } 
    else if (cur_time == "mid_afternoon")
    {
      if (imgSrc == "restaurant.png")
      {
        use_class = 2;
      } 
      else if (imgSrc == "resident.png" || imgSrc == "transit.png" )
      {
        use_class = 3;
      } 
      else if (imgSrc == "office.png" || imgSrc == "school.png" )
      {
        use_class = 2;
      } 
      else if (imgSrc == "recreation.png")
      {
        //the icon is inactive at this time
        use_class = 2;
      }
    }
    return use_class;
    
  }

}