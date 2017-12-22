[ w, h ] = size( I1 );%
img = Ia - Ia;
% sample_points = [ 2500 2500; 3000 3000 ];
[ n, ~ ] = size( sample_points );

V1 = zeros( w, h );
V2 = zeros( w, h );

for s = 1 : n
    
     if Valid( [ sample_points( s, 1 ), sample_points( s, 2 ) ], V1 )
         
         sample1 = [ sample_points( s, 2 ), sample_points( s, 1 ) ];
         sample2 = Transform( H, sample1 );
         epiLines1 = epipolarLine( F', sample2 );
         epiLines2 = epipolarLine( F, sample1 );
         
         L1 = Epipolar( epiLines1(1), epiLines1(2), epiLines1(3) );
         L2 = Epipolar( epiLines2(1), epiLines2(2), epiLines2(3) );
         
         [ n1, ~ ] = size( L1 );
         [ n2, ~ ] = size( L2 );
         
         if n2 > 150 && n1 > 150
             
             for q = 10 : n1 - 10
                 V1( L1 ( q, 1 ), L1 (q, 2) ) = 1;
             end

             disp ( [ ' Sample Point ', num2str( s ), ' In Process! ' ] );
             
             start_ = [ 0, 0 ];
             end_ = [ 0, 0 ]; %Target
             start__ = [ 0, 0 ];
             end__ = [ 0, 0 ]; %Fill
             
             for p = 10 : 50 : n1 - 10
                 
                 pts1 = [ L1( p, 2 ), L1( p, 1 ) ];
                 pts2 = Transform( H, pts1 );
                 
                 Epi1 = epipolarLine( F1, pts1 );
                 Epi2 = epipolarLine( F2', pts2 );
                 
                 PTS = Intersection( Epi1, Epi2 );
                 
                 if NotInRange( PTS( 1 ), PTS( 2 ), w, h ) == false
                     
                     if NotInRange( start_( 1 ), start_( 2 ), w, h ) == false
                         
                         end_ = PTS';
                         end__ = [ L1( p, 1 ), L1( p, 2 ) ];
                         
                         fill = L1( p - 50 : p, : );
                         
                         content = [ ];
                         
                         for i = 0 : round( norm( end_ - start_ ) )
                             
                             content = [ content; round( start_ + i * ( end_ - start_ ) / norm( end_ - start_ ) ) ];
                         
                         end
                         
                         if i > 10
                             
                             ratio = 50 / i;
                             
                             if ratio > 0.7 && ratio < 1.5
                                 for r = 1 : i - 1
                                     
                                     x1 = content( r, 1 );
                                     y1 = content( r, 2 );
                                     
                                     x2 = fill( 1 + floor(r * ratio ), 1 );
                                     y2 = fill( 1 + floor(r * ratio ), 2 );
                                     
                                     if NotInRange( x1, y1, w, h ) == false && NotInRange( x2, y2, w, h ) == false && img( x1, y1, 1 ) < 1
                                         
                                         img( x1, y1, : ) = Ia( x2, y2, : );
                                         
                                         for q = -10 : 10
                                             
                                             if x1 + q > 0 && x1 + q < w && x2 + q > 0 && x2 + q < w
                                                 
                                                 img( x1 + q, y1, : ) = Ia( x2 + q, y2, : );
                                                 
                                             end
                                             
                                         end
                                         
                                     end
                                     
                                 end
                             end
                             
                         end
                         
                     end
                     
                     start_ = PTS';
                     start__ = [ L1( p, 1 ), L1( p, 2 ) ];
                     
                 end
                 
                 
             end

             
             for p = 51 : 50 : n2 - 10
                 
                 pts1 = [ L2( p, 2 ), L2( p, 1 ) ];
                 pts2 = Transform( inv( H ), pts1 );
                 
                 Epi1 = epipolarLine( F2', pts1 );
                 Epi2 = epipolarLine( F1, pts2 );
                 
                 PTS = Intersection( Epi1, Epi2 );
                 
                 if NotInRange( PTS( 1 ), PTS( 2 ), w, h ) == false
                     
                     if NotInRange( start_( 1 ), start_( 2 ), w, h ) == false
                         
                         end_ = PTS';
                         end__ = [ L2( p, 1 ), L2( p, 2 ) ];
                         
                         fill = L2( p - 49 : p, : );
                         
                         content = [ ];
                         
                         for i = 0 : round( norm( end_ - start_ ) )
                             
                             content = [ content; round( start_ + i * ( end_ - start_ ) / norm( end_ - start_ ) ) ];
                         
                         end
                         
                         if i > 10
                             
                             ratio = 50 / i;
                             
                             if ratio > 0.7 && ratio < 1.5
                                 
                                 for r = 5 : i - 5
                                     
                                     x1 = content( r, 1 );
                                     y1 = content( r, 2 );
                                     
                                     x2 = fill( 1 + floor(r * ratio ), 1 );
                                     y2 = fill( 1 + floor(r * ratio ), 2 );
                                     
                                     if NotInRange( x1, y1, w, h ) == false && NotInRange( x2, y2, w, h ) == false && img( x1, y1, 1 ) < 1
                                         
                                         img( x1, y1, : ) = Ia( x2, y2, : );
                                         
                                         for q = -10 : 10
                                             
                                             if x1 + q > 0 && x1 + q < w && x2 + q > 0 && x2 + q < w
                                                 
                                                 img( x1 + q, y1, : ) = Ib( x2 + q, y2, : );
                                                 
                                             end
                                             
                                         end
                                         
                                     end
                                     
                                 end
                                 
                             end
                             
                         end
                         
                     end
                     
                     start_ = PTS';
                     start__ = [ L2( p, 1 ), L2( p, 2 ) ];
                     
                 end
                 
                 
             end             
             
         else
             
             disp ( [ ' Sample Point ', num2str( s ), ' Not In Border Or Too Short! ' ] );
             
         end
         
         
     end
    
    
end