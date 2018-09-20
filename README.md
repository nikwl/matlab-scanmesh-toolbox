# matlab-scanmesh-toolbox
## Overview
This is a toolbox of matlab functions to import, process, and export 3D meshes. 

Primary appliation is for processing scanned 3D meshes. Our lab generates 
3D reconstructions using photogrammetry software with extremely high resolution input images. 
These meshes often have millions of vertices, are incorrectly scaled, and display hard-to-find 
artifacts. This toolbox provides methods to help deal with these side-effects.

All of the provided methods run "fast" on very large mesh files. Parallelization is implemented using
default matlab functions whenever possible. If you find any potential missed opportunities for optimization 
contact me and I'll check it out.

## Methods
### Import Export
#### read_object, write-object
Methods to read and write .obj files. These files will parse vertices, vertex normals, vertex textures, 
faces, face normals, and face textures. Does not save any material or texture files. As far as I know
this is the fastest existing .obj reader implementation for matlab. 

### Visulization
#### vis_object vis_object_segment
Methods to visulize objects using matlab's patch function. vis_object displays the entire object in 
a single color, while vis_object_segment will highlight a specific part of the object. 

### Rescale Object with Known Ground-Truth
#### perform_manual_rescale
Method to scale an object using known ground truth object. Requires an object of known 
physical size which was scanned at the same time as the object to be scaled (I recommend a cube).

### Align Two Objects with ICP
#### perform_manual_align
Method to align two objects to one another. Requires selecting three points on each object. Object
alignment is updated after every point, and the final point snaps the objects using ICP.

### Recompute Normals
#### perform_recompute_facenormals
Method that recomputes an object's vertex normals and face normals.

### Segmenting
#### compute_segmentation
Method to devide an object into its connected components. Useful to identify small artifacts. 

### Finding Faces or Vertices
#### compute_find_faces, compute_find_vertices
Methods that return all faces that refernce a list of vertices, or returns all vertices that are 
referenced by a list of faces. 

### Deleting Vertices
#### perform_delete_vertices, perform_delete_duplicate_vertices, perform_delete_unreferenced_vertices
Methods that delete a list of vertices from an object, identify and remove duplicate vertices 
from an object, or remove vertices that are not referenced in the face list. Cleans up faces and 
and vertices after removal. Useful for removing identified artifacts or cleaning up an object. 

### Object Transforms
#### perform_rotation, perform_scaling, perform_translation, perform_matrix_transform
Methods to rotate, scale, and translate an object about a given axis, point or with a given matrix. 
Each transformation returns a matrix, and matrices can be applied in sequence using matrix_transform.

