let rec read ic acc=        (*Reads content of the file line by line and concatenates it into a string*)
        try
            let line= input_line ic in
            let ul= acc^(String.trim line ) in
            read ic ul
        with
        |   End_of_file -> let ()= close_in ic in
                            acc
        
let hex n v=            (*It maps integer values in the grid to corresponding values.Not required for n=3 but required for n=4 to include 0*)
    let hexad=          
        if n=4 then 
            "0123456789ABCDEF"
        else
            "123456789"
        in
        
    if v>=1 && v<=(n*n) then String.make 1 hexad.[v-1]  (*uses v-1 to avoid index out of bounds error*)
    else                                                   (*also converts it to string for printing*)
        ""

let rowreader n row_arr=        (*Converts a row array to list, apply hex function and then prints it*)
    let lis= Array.to_list row_arr in

    let lis= List.map (hex n) lis in
    print_endline (String.concat "" lis)

let rec allreader n matrix r totalrows=     (*applies rowreader to all rows*)
    if r>=totalrows then ()
    else
        begin
            rowreader n matrix.(r);
            allreader n matrix (r+1) totalrows
        end

let()=
    let an= Sys.argv.(1) in
    let ic= open_in an in       
    let line= input_line ic in
    if String.trim line="s SATISFIABLE" then    
    begin
        let acc= read ic ""  in
        let lis= String.split_on_char ' ' acc in    (*converts string to list and then filter and extract numberic variables*)
        let lis= List.filter (fun x-> x<> "" && x<>"v" && x<>"0" && x<>"s" && x<>"SATISFIABLE") lis in
        let len=List.length lis in 
        let sq= int_of_float ((float_of_int len)** (1.0/. 3.0) +. 0.5) in 
        let n= int_of_float(sqrt(float_of_int sq)+. 0.5) in
    
        let grid= Array.make_matrix sq sq 0 in  (*a global grid to fill values*)

        let temp= open_out "adcl.txt" in    (*temp file adcl to hold extra clauses to check for multiple solution*)
        let rec decoder sq grid list= match list with
            []->
                Printf.fprintf temp "0\n";  (*printing 0 in the end of adcl file*)
                close_out temp                 (*closing out channel*)
            | x::xs->
                let id= int_of_string x in 
                if id>0 then
                    begin
                       
                        let v= ((id-1) mod (n*n)) +1 in     (*extraction of value column and row and placing it in the grid*)
                        let c= (((id-1)/(n*n))mod (n*n)) +1 in
                        let r= ((id-1)/((n*n*n*n)))+1 in
                        grid.(r-1).(c-1) <- v;
                        Printf.fprintf  temp "-%d " id; (*printing the negative or of all the literal in the adcl file*)
                        decoder sq grid xs



                    end
                else
                    decoder sq grid xs
            in

        decoder sq grid lis;
        allreader n grid 0 sq
    end
        
    else
        print_endline("no solution exists")  

    


   









