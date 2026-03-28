
let get_id n r c v= 
    let sq= n*n in
        ((r-1)*sq*sq)+(c-1)*sq+(v)         (*get variable id for each atomic variable*)




let c1 n r c =                                  (*Clause c1-> Logical proposition of having atleast one value per square*)
    let sq=n*n in
    let values= List.init sq(fun i-> i+1) in 
    let ids= List.map (fun v->get_id n r c v) values in     (*For all values v from 1 to sq for a proposition variable you print or of them*)
    let st= List.map( fun v-> string_of_int v) ids in
    (String.concat " " st)^" 0"



(*clause c3-> unique value within a column*)
let rec c3 n r1 r2 c v acc=         
    let sq=n*n in
    if r2>sq then (acc)
    else
        begin
            let id1= get_id n r1 c v in         (*Get ids of both the row variables and then print the logical expression*)
            let id2= get_id n r2 c v in 
            let cl=("-"^string_of_int id1 ^ " -"^string_of_int id2 ^ " 0") in       (*not(a & b)*)
            c3 n r1 (r2+1) c v (cl::acc)
        end

(*a helper function for clause c3, it applies function c3 to each row of a column*)
let rec c3o n r1 c v acc=
    let sq =n *n in 
    if r1>sq-1 then (acc)
    else
        begin
            let acc=c3 n r1 (r1+1) c v acc in
            c3o n (r1+1) c v acc        (*Recursive call to c3o for next row value*)
        end

(*helper function for clause c3, it applies c3 to each value v*) 
let rec c3v n c v acc=
    let sq=n*n in
    if v>sq then (acc)
    else
        begin 

            let acc= c3o n 1 c v acc in
            c3v n c (v+1) acc
        end
(*Helper function for c3, it applies c3 to each column in the grid*)
let rec allc n c acc=
    let sq=n*n in
    if c>sq then (acc)
    else
        begin
            let acc=c3v n c 1 acc in
            allc n (c+1) acc
        end


(*Clause c4-> ensures no duplicacy in values in a row*)
let rec c4 n r c1 c2 v acc=
    let sq=n*n in
    if c2>sq then (acc)
    else 
        begin
            let idc1= get_id n r c1 v in
            let idc2= get_id n r c2 v in
            let cl= ("-"^string_of_int idc1 ^ " -"^string_of_int idc2 ^ " 0") in    (*not(a & b)= -a||-b*)
            c4 n r c1 (c2+1) v (cl::acc)
        end
(*helper function for c4, it applies c4 to a full row*)
let rec c4o n r c1 v acc=
    let sq=n*n in
    if c1>sq-1 then (acc)
    else 
        begin
            let acc=c4 n r c1 (c1+1) v acc in       (*calling c4 that compares value v of column c1 to c1+n*)
            c4o n r (c1+1) v acc            (*recursive call to c4o*)
        end

(*Helper function that applies c4 to each value v*)
let rec c4v n r v acc=
    let sq=n*n in
    if v>sq then (acc)
    else 
        begin

            let acc= c4o n r 1 v acc in
            c4v n r (v+1) acc
        end

(*Helper function that applies c4 to each row*)
let rec allr n r acc=
    let sq=n*n in
    if r>sq then (acc)
    else
        begin   
            let acc=c4v n r 1 acc in
            allr n (r+1) acc
        end



(*Clause c2-> It ensures Square cell can hold max of one value only*)
let rec c2 n r c v1 v2 acc=
    let sq=n*n in
    if v2>sq then 
    (acc)
    else
        begin 
            let id1= get_id n r c v1 in
            let id2= get_id n r c v2 in
            let cl= ("-"^string_of_int id1 ^ " -"^string_of_int id2 ^ " 0") in  (*variables for diffrent values for same square cannot be both true at a same time*)

            c2 n r c v1 (v2+1) (cl::acc)    (*Check for next value*)
        end

(*applies c2 for all values possible upto sq*)
let rec c2o n r c v1 acc=
    let sq=n*n in
    if v1>sq-1 then 
    (acc)
    else 
        begin 

            let acc=c2 n r c v1 (v1+1) acc in
            c2o n r c (v1+1) acc
        end
(*applies c2 and c1 both to each square cell in the row*)
let rec cols n r c acc=
    let sq=n*n in
    if c>sq then
        (acc)
    else
        begin 
            let acc=(c1 n r c) :: acc in        (*c1 call*)

            let acc=c2o n r c 1 acc in              (*c2 call*)
            cols n r (c+1) acc
            
        end

(*applies c1 and c2 to each row with use of cols function hence applying it to each square cell*)
let rec row n r  acc=      (*outermost function*)
    let sq=n*n in
    if r>sq then
        (acc)
    else
        begin
            let acc= cols n r 1 acc in
            row n (r+1) acc
        end

(*clause c5-> It ensures no two cells within a sublock have same value v*)
let rec c5 n r1 c1 inl v acc= match inl with    (*inl is a list of coordinates (r,c) of one block*)
    [] -> (acc)
    | (r2,c2) :: tail->             
        let idc51=get_id n r1 c1 v in
        let idc52 =get_id n r2 c2 v in
        let cl= ("-"^string_of_int idc51 ^ " -"^string_of_int idc52 ^ " 0") in  (*same value variable for 2 diffrent cells in a block cannot be true*)
        c5 n r1 c1 tail v (cl::acc)

(*Helper function to apply c5 to all poosible combination of coordinates in the list inl*)
let rec c5o n inl v acc= match inl with
    []-> (acc)
    | (r1,c1):: tail -> 
        let acc=c5 n r1 c1 tail v acc in
        c5o n tail v acc


   (*Get row function which collects coordinates of starting point of the block*) 
let rec getr n r c max_r lis=   (*max_r is r+n corresponding to value of r when function is called first time*)
    if r>max_r then (lis)
    else
        begin 
            
            getr n (r+1) c max_r ((r,c)::lis)
        end

(*Get all cordinates of n*n sublock in whole sudoku*)
let rec getall n r c max_c lis=
    if c>max_c then (lis)
    else 
        begin
            let ul= getr n r c (r+n-1) lis in
            getall n r (c+1) max_c ul
        end



(*it collects cordinates of the sublock by calling getall *)
let rec fullrow n r c acc=
    let sq=n*n in
    if r>sq then (acc)
    else 
        begin 
            let cordinates= getall n r c (n+c-1) [] in  (*defined max_c to be n+c-1*)
            let rec allv v iacc=
                if v>sq then (iacc)
                else
                    begin
                        
                        allv (v+1) (c5o n cordinates v iacc;)   (*callilng c5o on list coordinates*)
                    end in
            
            fullrow n (r+n) c (allv 1 acc)
        end


(*it iterates horizontally calling fullrow for each starting block column in the row*)
let rec allblocks n c acc=
    let sq=n*n in
    if c>sq then (acc)
    else
        begin
            let acc=fullrow n 1 c acc in
            allblocks n (c+n) acc
        end
        



(*String parser function*)
let rec par n s i acc=
    if i+1> String.length s then (acc)  
    else
        begin
            let r= i/(n*n)+1 in         (*obtaining row and column number from string index*)
            let c= i mod (n*n) +1 in
            let ch=s.[i] in
            let t1=     (*t1 is the mapping string which includes 0-9 and A-F for 4*4 and for all smaller n values it contains 1-9*)

                if n=4 then 
                    begin
                        "0123456789ABCDEF"  
                    end
                else 
                    begin
                        "123456789"
                    end   
                
            in
            
            let v= try (String.index t1 ch) +1 with _ -> -1 in      (*get corresponding value of prefilled cells for respective n, required due to 0 being used in 4*4 only*)  
            let nacc= 
                if v<> -1 then  (*If it was valid index then it would perform the if conditional*)
                    begin
                        let idv= string_of_int(get_id n r c (v)) in (*once we have n r c v we get it's id by getid function and then print unit clause to show prefilled values*)
                        (idv^ " 0") :: acc
                    end
                else acc
            in
            par n s (i+1) nacc  (*parser moves to next char in the string*)
        end


            

let rec print lis= match lis with       (*function to print content of the list*)
    []-> ()
    | x::xs -> print_endline x;
                print xs




let()= 



    let fn=Sys.argv.(1) in      (*opening file in directory*)
    let ic= open_in fn in          (*open channel*)
    let rec read acc=
        try
            let line= input_line ic in      (*reading line by line until eof error*)
            let ul= acc^(String.trim line ) in
            read ul
        with
        |   End_of_file -> let ()= close_in ic in
                            acc
        in

    

    let sudoku_str= read "" in 

    let len= String.length sudoku_str in

    let n=int_of_float(sqrt(sqrt(float_of_int len))) in
    let sq=n*n in
    let tv= sq*sq*sq in

    let allcl=      (*calling all the functions and storing result in list named acc*)
        []
        |> par n sudoku_str 0
        |> allc n 1
        |> row n 1
        |> allr n 1
        |> allblocks n 1
    in

    let count= List.length allcl in
    print_endline ("p cnf "^ string_of_int tv^" "^string_of_int count); (*printing the header for cnf format*)
    print allcl


    