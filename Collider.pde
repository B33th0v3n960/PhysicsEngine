interface Collider {
    boolean collides(CollisionBody other);
    boolean collidesWithRect(Rectangle other);
    boolean collidesWithEllipse(Ellipse other);
}

interface ColliderResolver {};

class RectCollider implements Collider {
    private Rectangle rectangle;

    public RectCollider(Rectangle rectangle) {
        this.rectangle = rectangle;
    }

    @Override
    boolean collides(CollisionBody other) {
        if (rectangle != null && other != null) {
            return other.collider.collidesWithRect(rectangle);
        }
        return false;
    }

    @Override
    boolean collidesWithRect(Rectangle other) {
        if (rectangle != null && other != null) {
            float topRectangle1 = 0.0;
            float botRectangle1 = 0.0;
            float topRectangle2 = 0.0;
            float botRectangle2 = 0.0;
            float projection1 = 0.0;
            float projection2 = 0.0;
            float[][] rectangleEdgeNormal = rectangle.getEdgeNormal();
            float[][] otherEdgeNormal = other.getEdgeNormal();
            
            for (int column = 0; column < rectangleEdgeNormal[0].length; column++) {
                float axis[] = {rectangleEdgeNormal[0][column], rectangleEdgeNormal[1][column], 1};

                for (int vertex = 0; vertex < rectangle.vertices.length; vertex++) {
                    if ( axis[0] != 0) {
                        projection1 = Vector.projection(axis,rectangle.vertices[vertex])[0] / axis[0];
                        projection2 = Vector.projection(axis, other.vertices[vertex])[0] / axis[0];
                    } else {
                        projection1 = Vector.projection(axis,rectangle.vertices[vertex])[1] / axis[1];
                        projection2 = Vector.projection(axis, other.vertices[vertex])[1] / axis[1];
                    }
                
                    if (vertex == 0) {
                        topRectangle1 = projection1;
                        botRectangle1 = projection1;
                        topRectangle2 = projection2;
                        botRectangle2 = projection2;
                    }  
                    topRectangle1 = (projection1 > topRectangle1)? projection1: topRectangle1;
                    botRectangle1 = (projection1 < botRectangle1)? projection1: botRectangle1;
                    topRectangle2 = (projection2 > topRectangle2)? projection2: topRectangle2;
                    botRectangle2 = (projection2 < botRectangle2)? projection2: botRectangle2;
                }

                if (!(topRectangle1 > botRectangle2 && topRectangle2 > botRectangle1))
                    return false;      
            }
            
            for (int column = 0; column < otherEdgeNormal[0].length; column++) {
                float axis[] = {otherEdgeNormal[0][column], otherEdgeNormal[1][column], 1};
                for (int vertex = 0; vertex < other.vertices.length; vertex++) {
                if ( axis[0] != 0) {
                    projection1 = Vector.projection(axis, rectangle.vertices[vertex])[0] / axis[0];
                    projection2 = Vector.projection(axis, other.vertices[vertex])[0] / axis[0];
                } else {
                    projection1 = Vector.projection(axis,rectangle.vertices[vertex])[1] / axis[1];
                    projection2 = Vector.projection(axis,other.vertices[vertex])[1] / axis[1];
                }
                
                if (vertex == 0) {
                    topRectangle1 = projection1;
                    botRectangle1 = projection1;
                    topRectangle2 = projection2;
                    botRectangle2 = projection2;
                }
                topRectangle1 = (projection1 > topRectangle1)? projection1: topRectangle1;
                botRectangle1 = (projection1 < botRectangle1)? projection1: botRectangle1;
                topRectangle2 = (projection2 > topRectangle2)? projection2: topRectangle2;
                botRectangle2 = (projection2 < botRectangle2)? projection2: botRectangle2;
                }
                if (!(topRectangle1 > botRectangle2 && topRectangle2 > botRectangle1))
                    return false;
            }
            return true;
        }
        return false;
    }

    @Override 
    boolean collidesWithEllipse(Ellipse other) {
        if (rectangle != null && other != null) {
            float[][] edgeNormal = rectangle.getEdgeNormal();
            float radius = other.getWidth()/2;
            float circleCenter[] = {other.getX(), other.getY(), 1};

            float projection1 = 0.0;
            float projection2 = 0.0;
            float topRectangle = 0.0;
            float botRectangle = 0.0;
            float topCircle = 0.0;
            float botCircle = 0.0;

            for (int column = 0; column < 2; column++){
                float axis[] = {edgeNormal[0][column], edgeNormal[1][column], 1};

            
                for (int vertex = 0; vertex < rectangle.vertices.length; vertex++) {
                    if ( axis[0] != 0) 
                        projection1 = Vector.projection(axis,rectangle.vertices[vertex])[0] / axis[0];
                    else 
                        projection1 = Vector.projection(axis,rectangle.vertices[vertex])[1] / axis[1];
            
                    if (vertex == 0) {
                        topRectangle = projection1;
                        botRectangle = projection1;
                    }

                    topRectangle = (projection1 > topRectangle)? projection1: topRectangle;
                    botRectangle = (projection1 < botRectangle)? projection1: botRectangle;
                }

                if ( axis[0] != 0) 
                    projection2 = Vector.projection(axis, circleCenter)[0] / axis[0];
                else 
                    projection2 = Vector.projection(axis,circleCenter)[1] / axis[1];
                topCircle = projection2 + radius;
                botCircle = projection2 - radius;
                if (!(topRectangle > botCircle && topCircle > botRectangle))         
                    return false;
            }

            float shortestDistance = sqrt(pow(circleCenter[0] - rectangle.vertices[0][0], 2) + pow(circleCenter[1] - rectangle.vertices[0][1], 2));
            for (float vertex[]: rectangle.vertices)  {
                float distance = sqrt(pow(circleCenter[0] - vertex[0], 2) + pow(circleCenter[1] - vertex[1], 2));
                if (distance < shortestDistance)
                    shortestDistance = distance;
            }
            if (shortestDistance < radius)
                return true;
        }
        return false;
    }
}

class EllipseCollider implements Collider {
    private Ellipse ellipse;

    public EllipseCollider(Ellipse ellipse) {
        this.ellipse = ellipse;
    }

    @Override
    boolean collides(CollisionBody other) {
        if (ellipse != null && other != null) {
            return other.collider.collidesWithEllipse(ellipse);
        }
        return false;
    }

    @Override
    boolean collidesWithRect(Rectangle other) {
        if (ellipse != null && other != null) {
            float[][] edgeNormal = other.getEdgeNormal();
            float radius = ellipse.getWidth()/2;
            float circleCenter[] = {ellipse.getX(), ellipse.getY(), 1};

            float projection1 = 0.0;
            float projection2 = 0.0;
            float topRectangle = 0.0;
            float botRectangle = 0.0;
            float topCircle = 0.0;
            float botCircle = 0.0;

            for (int column = 0; column < 2; column++){
                float axis[] = {edgeNormal[0][column], edgeNormal[1][column], 1};

            
                for (int vertex = 0; vertex < other.vertices.length; vertex++) {
                    if ( axis[0] != 0) 
                        projection1 = Vector.projection(axis, other.vertices[vertex])[0] / axis[0];
                    else 
                        projection1 = Vector.projection(axis, other.vertices[vertex])[1] / axis[1];
            
                    if (vertex == 0) {
                        topRectangle = projection1;
                        botRectangle = projection1;
                    }

                    topRectangle = (projection1 > topRectangle)? projection1: topRectangle;
                    botRectangle = (projection1 < botRectangle)? projection1: botRectangle;
                }

                if ( axis[0] != 0) 
                    projection2 = Vector.projection(axis, circleCenter)[0] / axis[0];
                else 
                    projection2 = Vector.projection(axis,circleCenter)[1] / axis[1];
                topCircle = projection2 + radius;
                botCircle = projection2 - radius;

                if (!(topRectangle > botCircle && topCircle > botRectangle))         
                    return false;
            }
            
            float shortestDistance = sqrt(pow(circleCenter[0] - other.vertices[0][0], 2) + pow(circleCenter[1] - other.vertices[0][1], 2));
            for (float vertex[]: other.vertices)  {
                float distance = sqrt(pow(circleCenter[0] - vertex[0], 2) + pow(circleCenter[1] - vertex[1], 2));
                if (distance < shortestDistance)
                    shortestDistance = distance;
                    
            }
            if (shortestDistance < radius)
                return true;
        }
        return false;
    }

    @Override 
    boolean collidesWithEllipse(Ellipse other) {
        if (ellipse != null && other != null) {
            float centreToCentre[] = { other.getX() - ellipse.getX(), other.getY() - ellipse.getY()};
            float distanceBetweenCentre = Vector.magnitude(centreToCentre);
            return distanceBetweenCentre < ellipse.getWidth()/2 + other.getWidth()/2;
        }
        return false;
    }
}