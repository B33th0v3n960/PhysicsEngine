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
                float axis[] = {rectangleEdgeNormal[0][column], rectangleEdgeNormal[1][column]};

                for (int vertex = 0; vertex < rectangle.vertices.length; vertex++) {
                    float point1[] = {rectangle.vertices[vertex][0], rectangle.vertices[vertex][1]};
                    float point2[] = {other.vertices[vertex][0], other.vertices[vertex][1]};
                    if ( axis[0] != 0) {
                        projection1 = Vector.projection(axis,point1)[0] / axis[0];
                        projection2 = Vector.projection(axis, point2)[0] / axis[0];
                    } else {
                        projection1 = Vector.projection(axis,point1)[1] / axis[1];
                        projection2 = Vector.projection(axis, point2)[1] / axis[1];
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
                float axis[] = {otherEdgeNormal[0][column], otherEdgeNormal[1][column]};
                for (int vertex = 0; vertex < other.vertices.length; vertex++) {
                    float point1[] = {rectangle.vertices[vertex][0], rectangle.vertices[vertex][1]};
                    float point2[] = {other.vertices[vertex][0], other.vertices[vertex][1]};
                    if ( axis[0] != 0) {
                        projection1 = Vector.projection(axis,point1)[0] / axis[0];
                        projection2 = Vector.projection(axis, point2)[0] / axis[0];
                    } else {
                        projection1 = Vector.projection(axis,point1)[1] / axis[1];
                        projection2 = Vector.projection(axis, point2)[1] / axis[1];
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
            float circleCenter[] = {other.getX(), other.getY()};
            float rectangleCenter[] = {rectangle.getX(), rectangle.getY()};

            float projection1 = 0.0;
            float projection2 = 0.0;
            float topRectangle = 0.0;
            float botRectangle = 0.0;
            float topCircle = 0.0;
            float botCircle = 0.0;

            for (int column = 0; column < 2; column++){
                float axis[] = {edgeNormal[0][column], edgeNormal[1][column]};
            
                for (int vertex = 0; vertex < rectangle.vertices.length; vertex++) {
                    float point[] = {rectangle.vertices[vertex][0], rectangle.vertices[vertex][1]};
                    if ( axis[0] != 0) 
                        projection1 = Vector.projection(axis, point)[0] / axis[0];
                    else 
                        projection1 = Vector.projection(axis,point)[1] / axis[1];
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

            float axis[] = {circleCenter[0] - rectangleCenter[0], circleCenter[1] - rectangleCenter[1]};
            axis = Vector.scalarMul(1/Vector.magnitude(axis), axis);
            for (int vertex = 0; vertex < rectangle.vertices.length; vertex++) {
                float point[] = {rectangle.vertices[vertex][0], rectangle.vertices[vertex][1]};
                if ( axis[0] != 0) 
                    projection1 = Vector.projection(axis, point)[0] / axis[0];
                else 
                    projection1 = Vector.projection(axis,point)[1] / axis[1];
                if (vertex == 0) {
                    topRectangle = projection1;
                    botRectangle = projection1;
                }
                topRectangle = (projection1 > topRectangle)? projection1: topRectangle;
                botRectangle = (projection1 < botRectangle)? projection1: botRectangle;
            }

            float centerProjection[] = Vector.projection(axis, circleCenter);
            if ( axis[0] != 0) {
                botCircle = centerProjection[0]/ axis[0] - radius;
                topCircle = centerProjection[0]/ axis[0] + radius;
                if (topCircle < botCircle) {
                    botCircle += topCircle;
                    topCircle = botCircle - topCircle;
                    topCircle -= botCircle;
                }
            }
            else {
                botCircle = centerProjection[1]/ axis[1] - radius;
                topCircle = centerProjection[1]/ axis[1] + radius;
                if (topCircle < botCircle) {
                    botCircle += topCircle;
                    topCircle = botCircle - topCircle;
                    topCircle -= botCircle;
                }
            }
            if (!(topRectangle > botCircle && topCircle > botRectangle))         
                return false;

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
            float circleCenter[] = {ellipse.getX(), ellipse.getY()};
            float rectangleCenter[] = {other.getX(), other.getY()};

            float projection1 = 0.0;
            float projection2 = 0.0;
            float topRectangle = 0.0;
            float botRectangle = 0.0;
            float topCircle = 0.0;
            float botCircle = 0.0;

            for (int column = 0; column < 2; column++){
                float axis[] = {edgeNormal[0][column], edgeNormal[1][column]};

            
                for (int vertex = 0; vertex < other.vertices.length; vertex++) {
                    float point[] = {other.vertices[vertex][0], other.vertices[vertex][1]};
                    if ( axis[0] != 0) 
                        projection1 = Vector.projection(axis, point)[0] / axis[0];
                    else 
                        projection1 = Vector.projection(axis, point)[1] / axis[1];
            
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
            
            float axis[] = {circleCenter[0] - rectangleCenter[0], circleCenter[1] - rectangleCenter[1]};
            axis = Vector.scalarMul(1/Vector.magnitude(axis), axis);
            for (int vertex = 0; vertex < other.vertices.length; vertex++) {
                float point[] = {other.vertices[vertex][0], other.vertices[vertex][1]};
                if ( axis[0] != 0) 
                    projection1 = Vector.projection(axis, point)[0] / axis[0];
                else 
                    projection1 = Vector.projection(axis,point)[1] / axis[1];
                if (vertex == 0) {
                    topRectangle = projection1;
                    botRectangle = projection1;
                }
                topRectangle = (projection1 > topRectangle)? projection1: topRectangle;
                botRectangle = (projection1 < botRectangle)? projection1: botRectangle;
            }

            float centerProjection[] = Vector.projection(axis, circleCenter);
            if ( axis[0] != 0) {
                botCircle = centerProjection[0]/ axis[0] - radius;
                topCircle = centerProjection[0]/ axis[0] + radius;
                if (topCircle < botCircle) {
                    botCircle += topCircle;
                    topCircle = botCircle - topCircle;
                    topCircle -= botCircle;
                }
            }
            else {
                botCircle = centerProjection[1]/ axis[1] - radius;
                topCircle = centerProjection[1]/ axis[1] + radius;
                if (topCircle < botCircle) {
                    botCircle += topCircle;
                    topCircle = botCircle - topCircle;
                    topCircle -= botCircle;
                }
            }

            if (!(topRectangle > botCircle && topCircle > botRectangle))         
                return false;
            return true;

        }
        return false;
    }

    @Override 
    boolean collidesWithEllipse(Ellipse other) {
        if (ellipse != null && other != null) {
            float centreToCentre[] = { other.getX() - ellipse.getX(), other.getY() - ellipse.getY()};
            float distanceBetweenCentre = Vector.magnitude(centreToCentre);
            if (distanceBetweenCentre < ellipse.getWidth()/2 + other.getWidth()/2) {
                return true;
            }
            return false;
        }
        return false;
    }
}