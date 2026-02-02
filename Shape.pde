abstract class Shape {
    private float x = 0.0;
    private float y = 0.0;
    private float shapeWidth = 0.0;
    private float shapeHeight = 0.0; 
    private float angle = 0.0;
    private color shapeColor = #000000;

    // NOTE: edgeNormal is a row major matrix
    private float edgeNormal[][] = {{1, 0, x}, {0,1, 0, y}, {0, 0, 1}};

    public Shape(float x, float y, float shapeWidth, float shapeHeight, color shapeColor) {
        this.x = x;
        this.y = y;
        this.shapeWidth = shapeWidth;
        this.shapeHeight = shapeHeight;
        this.shapeColor = shapeColor;
    }

    public float getX() {
        return x;
    }
    
    public void setX(float x) {
        if (x > -10000 && x < 10000)
            this.x = x;
    }

    public float getY() {
        return y;
    }

    public void setY(float y) {
        if (y > -10000 && y < 10000)
            this.y = y;
    }
    
    public float getAngle() {
        return angle;
    }

    public void setAngle(float angle) {
        this.angle = angle % TWO_PI;
    }
    
    public float getWidth() {
        return shapeWidth;
    }

    public float getHeight() {
        return shapeHeight;
    }

    public float[][] getEdgeNormal() {
        return edgeNormal;
    }

    public void draw(){
        drawStep(x, y, shapeWidth, shapeHeight, angle, shapeColor);
    }

    public void drawWrap() {
        float wrapX = 0.0;
        float wrapY = 0.0;

        // Left-Right bound wrap
        if (x + shapeWidth/2 > width) {
            wrapX = x - width;
            drawStep(wrapX, y, shapeWidth, shapeHeight, angle, shapeColor);
        } else if (x - shapeWidth/2 < 0) {
            wrapX = x + width;
            drawStep(wrapX, y, shapeWidth, shapeHeight, angle, shapeColor);
        }

        // Up-Down bound wrap 
        if (y + shapeHeight/2 > height) {
            wrapY = y - height;
            drawStep(x , wrapY, shapeWidth, shapeHeight, angle, shapeColor);
        } else if (y - shapeHeight/2 < 0) {
            wrapY = y + height;
            drawStep(x , wrapY, shapeWidth, shapeHeight, angle, shapeColor);
        }

        // Coner wraps
        if (x + shapeWidth/2 > width && y + shapeHeight/2 > height) {
            wrapX = x - width;
            wrapY = y - height;
            drawStep(wrapX, wrapY, shapeWidth, shapeHeight, angle, shapeColor);
        } else if (x + shapeWidth/2 > width && y - shapeHeight/2 < 0){
            wrapX = x - width;
            wrapY = y + height;
            drawStep(wrapX, wrapY, shapeWidth, shapeHeight, angle, shapeColor);
        } else if (x - shapeWidth/2 < 0 && y + shapeHeight/2 > height) {
            wrapX = x + width;
            wrapY = y - height;
            drawStep(wrapX, wrapY, shapeWidth, shapeHeight, angle, shapeColor);
        } else if (x - shapeWidth/2 < 0 && y - shapeHeight/2 < 0){
            wrapX = x + width;
            wrapY = y + height;
            drawStep(wrapX, wrapY, shapeWidth, shapeHeight, angle, shapeColor);
        } 

        // If original move offscreen, move it to wrap
        setX((x - shapeWidth/2 > width || x < - shapeWidth/2) ? wrapX: x);
        setY((y - shapeHeight/2 > height || y < - shapeHeight/2) ? wrapY: y);
    }

    public abstract void drawStep(float x, float y, float shapeWidth, float shapeHeight, float angle, color shapeColor);
}

class Rectangle extends Shape {

    // NOTE: vertices is a column major matrix
    private float vertices[][] = new float[4][3];

    public Rectangle(float x, float y, float shapeWidth, float shapeHeight, color shapeColor){
        super(x, y, shapeWidth, shapeHeight, shapeColor);
        updateVertices();
    }

    private void updateVertices() {
        float shapeWidth = super.getWidth();
        float shapeHeight = super.getHeight();
        float edgeNormal[][] = Matrix.rotationMatrix(super.getX(), super.getY(), super.getAngle());

        // NOTE: originVertices is a column major matrix
        float[][] originVertices = {
            {-shapeWidth/2, -shapeHeight/2, 1},
            { shapeWidth/2, -shapeHeight/2, 1},
            { shapeWidth/2,  shapeHeight/2, 1},
            {-shapeWidth/2,  shapeHeight/2, 1}
        };
        
        for (int vertex = 0; vertex < vertices.length; vertex++)
            vertices[vertex] = Matrix.multiply(edgeNormal, originVertices[vertex]);
    }

    public void setX(float x) {
        super.setX(x);
        updateVertices();
    }

    public void setY(float y) {
        super.setY(y);
        updateVertices();
    }

    public void setAngle(float angle) {
        super.setAngle(angle);
        super.edgeNormal = Matrix.rotationMatrix(super.getX(), super.getY(), angle);
        updateVertices();
    }

    @Override 
    public void drawStep(float x, float y, float shapeWidth, float shapeHeight, float angle, color shapeColor) {
        pushMatrix();
        translate(x ,y);
        rotate(angle);
        fill(shapeColor);
        rect(0, 0, shapeWidth, shapeHeight);
        popMatrix();
    }
}

class Ellipse extends Shape {
    public Ellipse(float x, float y, float shapeWidth, float shapeHeight, color shapeColor){
        super(x, y, shapeWidth, shapeHeight, shapeColor);
    }

    @Override 
    public void drawStep(float x, float y, float shapeWidth, float shapeHeight, float angle, color shapeColor) {
        pushMatrix();
        translate(x ,y);
        rotate(angle);
        fill(shapeColor);
        ellipse(0, 0, shapeWidth, shapeHeight);
        popMatrix();
    }
}