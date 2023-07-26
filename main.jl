using Random
using Statistics

# Function to calculate Euclidean distance between two points
function euclidean_distance(x, y)
    return sqrt(sum((x .- y).^2))
end

# K-means clustering function
function kmeans(data, k, max_iter=100)
    n, d = size(data)
    centroids = data[shuffle(1:n)[1:k], :]
    cluster_assignments = zeros(Int, n)
    total_square_distances = Inf
    
    for iter in 1:max_iter
        println("iteration ", iter)
        println("distance: ", total_square_distances)
        # Assign points to the nearest centroid
        total_square_distances = 0
        for i in 1:n
            min_distance = Inf
            for j in 1:k
                distance = euclidean_distance(data[i, :], centroids[j, :])
                if distance < min_distance
                    cluster_assignments[i] = j
                    min_distance = distance
                end
            end
            total_square_distances += min_distance^2
        end
        
        
        for j in 1:k
            cluster_points = data[cluster_assignments .== j, :]
            centroids[j, :] = mean(cluster_points, dims=1)
        end
    end
    
    return centroids, cluster_assignments
end


using Images

function make_n_by_3(image)
    rows,columns = size(image)
    num_of_pixels = rows*columns
    return transpose(reshape(channelview(image),3,num_of_pixels))
end



function make_color_stripes(image, L_factor=0.4, k=6, k_iters=16)
    Lab_n_by_3 = make_n_by_3(convert.(Lab,image))
    rows,columns = size(image)
    
    Lab_n_by_3_adjusted_L = copy(Lab_n_by_3)
    Lab_n_by_3_adjusted_L[:,1] .*= L_factor

    centroids, cluster_assignments = kmeans(Lab_n_by_3_adjusted_L, k, k_iters)

    separated_colors_pic = copy(Lab_n_by_3[cluster_assignments .== 1,:])
    for i in 2:k
        separated_colors_pic = vcat(separated_colors_pic,Lab_n_by_3[cluster_assignments .== i,:])
    end

    return colorview(Lab,reshape(transpose(separated_colors_pic),3,rows,columns))
end

# Load the image
image = load("pictures/Mona_Lisa.jpg")
make_color_stripes(image)



for i in 1:num_of_pixels
    new_images[cluster_assignments[i],i,:] = Lab_vector[i,:]
end

display(img)
for i in 1:k
    display(colorview(Lab,reshape(transpose(new_images[i,:,:]),3,rows,columns)))
end
img