class Sprite {
    private CollisionBody collisionBody;

    public Sprite(float x, float y, float width, float height, int collisionBodyType) {
        collisionBody = new CollisionBody();
        switch(collisionBodyType) {
            case RECT:
                collisionBody.collisionShape = new Rectangle(x, y, width, height, #cdd3dd);
                collisionBody.collider = new RectCollider((Rectangle) collisionBody.collisionShape);
                break;
            case ELLIPSE:
                collisionBody.collisionShape = new Ellipse(x, y, width, height, #cdd3dd);
                collisionBody.collider = new EllipseCollider((Ellipse) collisionBody.collisionShape);
                break;
        }
    }

    public void drawHitBox() {
        collisionBody.showCollisionBody();
    }

    public void move(float dx, float dy){
        collisionBody.updateCollisionBody(dx, dy, 0);
    }

    public void turn(float dTheta) {
        collisionBody.updateCollisionBody(0, 0, dTheta);
    }

    public boolean collideWith(Sprite other) {
        return collisionBody.collider.collides(other.collisionBody);
    }
}