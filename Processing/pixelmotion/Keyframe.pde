import penner.easing.*;
class Keyframe {
  int beginFrame = 0;
  int time = 0;
  float beginning, change, duration;
  Keyframe(int bf, float b, float c, float d) {
    beginFrame = bf;
    beginning = b;
    change = c;
    duration = d;
  }

  void setBeginFrame(int bf) {
    beginFrame = bf;
  }

  void updateTime() {
    time = frameCount - beginFrame;
    time = time < 0 ? 0 : time;
    time = time > beginFrame + int(duration) ? beginFrame + int(duration) : time;
  }

  int getValue(String method, String type) {
    updateTime();
    if (method == "Linear" && type == "easeIn")
      return int(Linear.easeIn(time, beginning, change, duration));
    if (method == "Linear" && type == "easeOut")
      return int(Linear.easeOut(time, beginning, change, duration));
    if (method == "Linear" && type == "easeInOut")
      return int(Linear.easeInOut(time, beginning, change, duration));

    if (method == "Quad" && type == "easeIn")
      return int(Quad.easeIn(time, beginning, change, duration));
    if (method == "Quad" && type == "easeOut")
      return int(Quad.easeOut(time, beginning, change, duration));
    if (method == "Quad" && type == "easeInOut")
      return int(Quad.easeInOut(time, beginning, change, duration));

    if (method == "Cubic" && type == "easeIn")
      return int(Cubic.easeIn(time, beginning, change, duration));
    if (method == "Cubic" && type == "easeOut")
      return int(Cubic.easeOut(time, beginning, change, duration));
    if (method == "Cubic" && type == "easeInOut")
      return int(Cubic.easeInOut(time, beginning, change, duration));

    if (method == "Quart" && type == "easeIn")
      return int(Quart.easeIn(time, beginning, change, duration));
    if (method == "Quart" && type == "easeOut")
      return int(Quart.easeOut(time, beginning, change, duration));
    if (method == "Quart" && type == "easeInOut")
      return int(Quart.easeInOut(time, beginning, change, duration));

    if (method == "Quint" && type == "easeIn")
      return int(Quint.easeIn(time, beginning, change, duration));
    if (method == "Quint" && type == "easeOut")
      return int(Quint.easeOut(time, beginning, change, duration));
    if (method == "Quint" && type == "easeInOut")
      return int(Quint.easeInOut(time, beginning, change, duration));

    if (method == "Sine" && type == "easeIn")
      return int(Sine.easeIn(time, beginning, change, duration));
    if (method == "Sine" && type == "easeOut")
      return int(Sine.easeOut(time, beginning, change, duration));
    if (method == "Sine" && type == "easeInOut")
      return int(Sine.easeInOut(time, beginning, change, duration));

    if (method == "Circ" && type == "easeIn")
      return int(Circ.easeIn(time, beginning, change, duration));
    if (method == "Circ" && type == "easeOut")
      return int(Circ.easeOut(time, beginning, change, duration));
    if (method == "Circ" && type == "easeInOut")
      return int(Circ.easeInOut(time, beginning, change, duration));

    if (method == "Expo" && type == "easeIn")
      return int(Expo.easeIn(time, beginning, change, duration));
    if (method == "Expo" && type == "easeOut")
      return int(Expo.easeOut(time, beginning, change, duration));
    if (method == "Expo" && type == "easeInOut")
      return int(Expo.easeInOut(time, beginning, change, duration));

    if (method == "Back" && type == "easeIn")
      return int(Back.easeIn(time, beginning, change, duration));
    if (method == "Back" && type == "easeOut")
      return int(Back.easeOut(time, beginning, change, duration));
    if (method == "Back" && type == "easeInOut")
      return int(Back.easeInOut(time, beginning, change, duration));

    if (method == "Bounce" && type == "easeIn")
      return int(Bounce.easeIn(time, beginning, change, duration));
    if (method == "Bounce" && type == "easeOut")
      return int(Bounce.easeOut(time, beginning, change, duration));
    if (method == "Bounce" && type == "easeInOut")
      return int(Bounce.easeInOut(time, beginning, change, duration));

    if (method == "Elastic" && type == "easeIn")
      return int(Elastic.easeIn(time, beginning, change, duration));
    if (method == "Elastic" && type == "easeOut")
      return int(Elastic.easeOut(time, beginning, change, duration));
    if (method == "Elastic" && type == "easeInOut")
      return int(Elastic.easeInOut(time, beginning, change, duration));
    return 0;
  }
}
