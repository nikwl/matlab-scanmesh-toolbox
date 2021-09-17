# matlab-scanmesh-toolbox
## Overview
This is a toolbox of matlab functions to import, visulize, process, and export 3D meshes. 

Primary appliation is for processing scanned 3D meshes. Our lab generates 
3D reconstructions using photogrammetry software with extremely high resolution input images. 
These meshes often have millions of vertices, are incorrectly scaled, and display hard-to-find 
artifacts. This toolbox provides methods to help deal with these side-effects.

All of the provided methods run "fast" on very large mesh files. Parallelization is implemented using
default matlab functions whenever possible.

## Methods
### Import Export
#### read_object, write_object
Methods to read and write .obj files. These files will parse vertices, vertex normals, vertex textures, 
faces, face normals, and face textures. Does not save any material or texture files. As far as I know
this is the fastest existing .obj reader implementation for matlab. 

### Object Visualization
#### vis_object, vis_object_segment
Methods to visulize objects using matlab's patch function. vis_object displays the entire object in 
a single color, while vis_object_segment will highlight a specific part of the object. 

### Camera and Figure Tools
#### vis_copy_camera, vis_paste_camera, vis_fill_camera, vis_change_background
Copy and paste are methods to save and apply the current camera orientation and target, as well as xyz
limits. Fill camera expands or shrinks the xyz limits of the figure to the edges of the figure so that
the object is easier to see. Change background removes the axis from a figure and replaces the background 
with a solid specified color. 

### Colorize
#### colorize_recolor, colorize_curvature, colorize_centroiddistance
Recolor will recolor an input object to the specified color. Colorize curvature uses a simple approach to 
color vertices based on the placement of their adjacencies. Colorize centroid distance color vertices 
based on their distance from the object's center of mass. 

### Rescale Object with Known Ground-Truth
#### perform_manual_rescale
Method to scale an object using known ground truth object. Requires an object of known 
physical size which was scanned at the same time as the object to be scaled (I recommend a cube).

### Align Two Objects with ICP
#### perform_manual_align
Method to align two objects to one another. Requires selecting three points on each object. Object
alignment is updated after every point, and the final point snaps the objects using ICP.

### Transform Object
#### perform_rotation, perform_scaling, perform_translation, perform_matrix_transform
Methods to rotate, scale, and translate an object about a given axis, point or with a given matrix. 
Each transformation returns a matrix, and matrices can be applied in sequence using matrix_transform.

### Recompute Object Normals
#### perform_recompute_facenormals
Method that recomputes an object's vertex normals and face normals.

### Delete Specific Vertices
#### perform_delete_vertices, perform_delete_duplicate_vertices, perform_delete_unreferenced_vertices
Methods that delete a list of vertices from an object, identify and remove duplicate vertices 
from an object, or remove vertices that are not referenced in the face list. Cleans up faces and 
and vertices after removal. Useful for removing identified artifacts or cleaning up an object.

### Find Connected Components
#### compute_connectedcomponents
Method to devide an object into its connected components. Useful to identify small artifacts. 

### Find Specific Faces or Vertices
#### compute_find_faces, compute_find_vertices
Methods that return all faces that refernce a list of vertices, or returns all vertices that are 
referenced by a list of faces.  

### Compute Edges and Adjacencies
#### compute_adjacencylist, compute_adjacencymatrix, compute_edges
Methods to compute the adjacencies of an object, or edges of an object in stable or sorted order.

### Surface Pathfinding 
#### astar, dijkstra
Given start and ending vertices, vertex list, and adjacency list, will return the shortest path between 
two points. Implementation of dijkstra is essentially the same as astar with the cost function set to 
increment by one for each edge. Boolean value within each function lets you visulize the process.

