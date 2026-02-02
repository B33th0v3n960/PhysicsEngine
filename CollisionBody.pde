class CollisionBody {
    private Shape collisionShape; 
    private Collider collider;

    public void showCollisionBody() {
        collisionShape.draw();
        // collisionShape.drawWrap();
    }

    public boolean collidesWith(CollisionBody other) {
        return this.collider.collides(other);
    }

    public void updateCollisionBody(float dx, float dy, float dTheta) {
        collisionShape.setX(collisionShape.getX() + dx);
        collisionShape.setY(collisionShape.getY() + dy);
        collisionShape.setAngle(collisionShape.getAngle() + dTheta);
    }
}