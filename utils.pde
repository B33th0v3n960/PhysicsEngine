// import java.util.Arrays;

Sprite character = new Sprite(200, 200, 100, 100, ELLIPSE);
Sprite enemy = new Sprite(200, 200, 100, 100, ELLIPSE);
boolean keyz[] = new boolean[6];

int counter = 0;

void setup() {
    size(1280, 1440, P2D);
    surface.setTitle("Utils Testing");
    surface.setResizable(true);
    frameRate(60);

    noStroke();
    colorMode(HSB, 360, 100, 100);
    rectMode(CENTER);
    ellipseMode(CENTER);
}

void draw() {
    background(#2e3440);
    textSize(24);
    // text("Shape X: " + character.hitBox.getX(), 20, 30);
    // text("Shape Y: " + character.hitBox.getY(), 20, 60);
    // text("Shape width: " + myShape.getWidth(), 20, 90);
    // text("Shape width: " + myShape.getHeight(), 20, 120);

    System.out.println();
    if (character.collideWith(enemy)) {
        System.out.println("Collision Detected" + counter++);
    }

    // System.out.println("MouseX: " + mouseX);
    // System.out.println("MouseY: " + mouseY);

    if (keyPressed == true) {
        if (keyz[0])
            character.move(0, -5);
        if (keyz[2])
            character.move(0, 5);
        if (keyz[1])
            character.move(-5,0);
        if (keyz[3])
            character.move(5,0);

        if (keyz[4])
            enemy.turn(-PI/60);
        if (keyz[5])
            enemy.turn(PI/60);

    }
    enemy.drawHitBox();
    character.drawHitBox();
}

void keyPressed() {
  if (key == 'w' || key == 'W')  keyz[0] = true;
  if (key == 'a' || key == 'A')  keyz[1] = true;
  if (key == 's' || key == 'S')  keyz[2] = true;
  if (key == 'd' || key == 'D')  keyz[3] = true;
  if (keyCode == LEFT) keyz[4] = true;
  if (keyCode == RIGHT) keyz[5] = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W')  keyz[0] = false;
  if (key == 'a' || key == 'A')  keyz[1] = false;
  if (key == 's' || key == 'S')  keyz[2] = false;
  if (key == 'd' || key == 'D')  keyz[3] = false;
  if (keyCode == LEFT) keyz[4] = false;
  if (keyCode == RIGHT) keyz[5] = false;
}