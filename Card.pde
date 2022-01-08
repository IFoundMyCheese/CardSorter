class Card {
  int num;
  PImage img;
  float scale;
  String name;
  float x;
  float y;
  float startingX;
  float startingY;
  float l;
  float deltaX = 0;
  float deltaY = 0;
  float delta = 0;

  Card(int n, String i, float s) {
    this.num = n;
    this.img = loadImage("PNG/" + i + ".png");
    this.scale = s;
    this.name = i;
    this.img.resize(int(this.img.width*this.scale), int(this.img.height*this.scale));
  }

  void saveCoordinates(float x) {
    this.x = x;
    this.y = (height-this.img.height)/2.0;
    this.startingX = (width-this.img.width)/2.0;
    this.startingY = 0;
  }

  void drawCards() {
    image(this.img, this.startingX, this.startingY);
    if (round(this.startingX) != round(this.x)) {
      if (round(this.startingX) > round(this.x)) {
        this.startingX -= (this.startingX-this.x)/(speed*2);
      } else if (round(this.startingX) < round(this.x)) {
        this.startingX += (this.x-this.startingX)/(speed*2);
      }
    }
    if (round(this.startingY) != round(this.y)) {
      if (abs(round(this.startingY) - round(this.y)) > 0 && abs(round(this.startingY) - round(this.y)) < 1) {
        this.y = this.startingY;
      } else {
        this.startingY += (this.y - this.startingY)/(speed*2);
      }
    } else {
      this.x = this.startingX;
      this.y = this.startingY;
      moveToNextCard = true;
    }
  }
  
  
  void linear(Card other, Card other2) {
    if ((this != other && this != other2)) {
      image(this.img, this.x, this.y);
    }
    if (swap == true && (this == other)) {
      image(other.img, other.x + deltaX, other.y);
      image(other2.img, other2.x - deltaX, other2.y);
      //println(round((other.x + deltaX)), round(other2.x));
      if (round((other.x + deltaX)) == round(other2.x)) { 
        other.x = other.x + deltaX;
        other2.x = other2.x - deltaX;
        bringToFront();
        deltaX = 0;
        swap = false;
      } else {
        if (abs(round(other.x + deltaX) - round(other2.x)) > 0 && abs(round(other.x + deltaX) - round(other2.x)) <= 1) {
          other.x = other.x + deltaX;
          other2.x = other2.x - deltaX;
          bringToFront();
          deltaX = 0;
          swap = false;
        } else {
          deltaX += (other2.x-other.x)/(4*speed);
        }
      }
    }
  }


  void circular(Card other, Card other2) {
    if ((this != other && this != other2)) {
      image(this.img, this.x, this.y);
    }
    if (swap == true && (this == other)) {
      if (sortingAlgorithm.equals("bubble sort")) {
        image(other.img, other.x + deltaX, other.y - deltaY);
        image(other2.img, other2.x - deltaX, other2.y + deltaY);
      } else if (sortingAlgorithm.equals("insertion sort")) {
        image(other2.img, other2.x - deltaX, other2.y + deltaY);
        image(other.img, other.x + deltaX, other.y - deltaY);
      } else {
        image(other2.img, other2.x + deltaX, other2.y - deltaY);
        image(other.img, other.x - deltaX, other.y + deltaY);
      }

      l = abs(other2.x - other.x);
      if (radians(delta) > PI) {
        //image(other2.img, other2.x - deltaX, other2.y + deltaY);
        if (sortingAlgorithm.equals("merge sort") || sortingAlgorithm.equals("quick sort") || sortingAlgorithm.equals("selection sort")) {
          other.x = other.x - deltaX;
          other2.x = other2.x + deltaX;
        } else {
          other.x = other.x + deltaX;
          other2.x = other2.x - deltaX;
        }
        bringToFront();
        delta = 0;
        swap = false;
      } else {
        deltaX = l*cos(radians(delta));
        deltaY = l*sin(radians(delta));
        delta += (6-speed)*4;
      }
    }
  }

  void keepDrawing() {
    image(this.img, this.startingX, this.startingY);
  }

  void drawAgain() {
    deltaX = 0;
    deltaY = 0;
    delta = 0;
    image(this.img, this.x, this.y);
  }


  void bringToFront() {
    for (int i = 0; i < animatedStack.size(); i++) {
      image(animatedStack.get(i).img, animatedStack.get(i).x, animatedStack.get(i).y);
    }
  }
}
