/*
* Time ids:
* 0: Morning
* 1: Noon
* 2: Afternoon
* 3: Evening
* 4: Late Evening
*/
class UseFlow
{
  String from_use;
  String to_use;
  int timeID;
  int delay;
  
  UseFlow (int time_select, String from, String to, int number)
  {
    timeID = time_select;
    from_use = from;
    to_use = to;
    delay = number;
  }
}