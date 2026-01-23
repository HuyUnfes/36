--[[ 
    IRONBREW FULL CONSTANT DUMPER & CLIPBOARD COPIER
    Tác dụng: Giải mã tất cả các chuỗi và copy vào bộ nhớ tạm.
]]

return(function(...)do local f,m,O,p,Q=math,table,tonumber,setmetatable,string local B,P,n,R,K,g=f.floor,f.max,Q.unpack,m.concat,Q.char,Q.sub local d="iiihhhiiiiihssss","\136%\250\025N\201pwzg\019(A_Y&l\r\200N\181\000\181\226\r\001O\134\212\001\a\202\154;\000\000\001\000\000\001\a\000\000\000__index\006\000\000\000__call\005\000\000\000__sub\005\000\000\000__mul"local U=1 local function k()if U+3<=#d then local f,m,O,p=d:byte(U,U+3)U=U+4 return((f+m*256)+O*65536)+p*16777216 end return 0 end local function E()if U+1<=#d then local f,m=d:byte(U,U+1)U=U+2 return f+m*256 end return 0 end local function L()local f=0 for m=U,#d,1 do if d:byte(m)==0 then f=m-U break end end if f>0 then local m=d:sub(U,(U+f)-1)U=(U+f)+1 return m end return""end local V=k()local H=k()local a=k()local M=E()local b=E()local W=E()local w=k()local G=k()local T=k()local t=k()local s=k()local A=E()local J=L()local Y=L()local q=L()local S=L()local o,l,c,Z,v,j,N,i,r,I=1,1,1,16807,48271,2147483647,2147483647,2147483647,2147483647,0 local function h()c,o,l=(j*c)%r,(Z*o)%N,(v*l)%i return B((((((o+w)+l)+G)+c)+T)/s)%A end local function e(f)local m={}for p=1,#f,2 do local Q=g(f,p,p+1)if Q and#Q==2 then local f=O(Q,16)if f then m[#m+1]=K(((f-h())+A)%A)end end end return m end _G["4Ura8exaM8MaQkO"]=xhider end local f={{76;"1BA9AEAF"},{15,"ABAF44"};{50;"1AA7ABA11AA745484118ACA7ADA1"};{11,"11A748A9A5ADAF"},{37;"1312FAF944A4411BAE471FF4"},{57;"B57DCF5018A640A7AFA159"},{35,"AD89"};{9;"F1AF4C411DA9A5AFAD"},{41;"AF4545A645"};{55,"12A147FC18A819"};{39;"1DA6A8A9ADF0ADA947AF45"};{78;"18A6ADA64588"};{2;"17A1ADAFA1"};{30;"F1AF4C41154F4141A6AB"};{72,"F74A12F1181AA1AB8048851CF5"};{65,"15A9A8A2A445A64FABA118A6ADA64588"};{21,"1EA64F48AF154F4141A6AB8918ADA7A8A2"};{56;"AD85"},{48,"41A6484145A7ABA4"};{85;"FF11A7AE"};{89;"1FAB4FAE"};{29;"AEA941AC"};{38;"F8A7A5ADA7ABA4"},{53;"1A87471E1E1843A11488ACA4"},{7,"1AA6AB41"};{80;"A4AEA941A8AC"},{22;"408481F4AD434FA4F7A9A1F3"},{49,"1EA64F48AF1DAFA94AAF"},{58,"AC41414048835656A1A748A8A645A15BA8A6AE56A7AB4AA741AF561F851B8444888F43A241"},{3,"1EA64F48AF1FAB41AF45"};{84,"818713168414FFA4F31D4487"},{67,"F8A743AF"},{44;"F6F6ADAFAB"},{47;"15AD4F451FAAAAAFA841"};{52,"F1AF4C41F8A743AF"},{34,"FF1718A645ABAF45"};{16;"F1AF4C41"};{82;"48AF41A8ADA740A5A6A945A1"};{19;"45A9ABA1A6AE"},{18;"F6F6A7ABA1AF4C"},{63;"A4AF41A8A6ABABAFA841A7A6AB48"},{83,"4FAB40A9A8A2"};{1;"FAA7B922C4418350F8A845A7404150D179D83850ADB92274A75041ACB9227EA75B50FA4FA750ADD825ABA4504AD830A65011A748A8A645A150D179B922C850ABACB9233EAB5048A845A7404150AEB92272A75B"};{86;"1FABA4ADA748AC8350F8A845A7404150A64F41A1A941AFA15B5013A6A7AB5011A748A8A645A15041A650A4AF4150ABAF445048A845A74041485B"};{45;"4A888912F48849121FA3F8F0FCA4"};{51;"1DF9A7481FF54AFAF8AA87A7FA"},{24;"F8A845AFAFAB144FA7"};{13,"1FABA9A5ADAFA1"},{71,"FAAFA841A64585"},{90;"F91484A14187"},{64,"FF11A7AE85"};{46;"40A8A9ADAD"},{25;"F1AF4C4118A6ADA64588"},{42,"607678C25018A640475011A748A8A645A1501DA7ABA2"},{79,"18A6ABABAFA841"},{73,"F0A945AFAB41"};{32,"19ABA8ACA645F0A6A7AB41"};{4,"484145A7ABA4"};{81;"414815ACABFF11A6884C1680"},{61,"83"},{10,"41A6AB4FAEA5AF45"},{8;"F1AF4C41F445A94040AFA1"},{6,"F7A64F501945AF501DA6484159"},{5;"F0ADA947AF4548"},{43,"F6F6A4A8"},{20,"17AB4841A9ABA8AF"},{69;"1D89"};{12,"4519A8F511F016F9801481F9F4"};{36;"835C5FA1535783"},{60,"4F811D154A87AB841D11A887F513"};{75,"18A645AF144FA7"};{17;"A4A9AEAF"};{54;"A8A6ABA8A941"},{87;"F317ABA1AF4C15AFACA94AA7A645"},{88;"ABAF4C41"},{14,"14AF41F8AF454AA7A8AF"},{31,"F0A648A741A7A6AB"},{62,"1E884C1A84F4F9A6A8F04443AC"},{91,"AA45A6AEF51415"};{40,"44A9A741"},{59;"1711A813"};{28;"A4484FA5"},{33;"894C43AFFF15A9F713FC4C1F"};{26;"15A9A8A2A445A64FABA1F145A9AB4840A945AFABA847"};{23;"17481DA6A9A1AFA1"},{27;"1DA7A4AC41A7ABA4"},{70;"AF4AA94CA68548F7"},{68,"41A9A5ADAF"};{74,"14A641ACA9AE15A6ADA1"};{77,"18A645ABAF45F5A9A1A74F48"};{66,"41A948A2"}}for m,O in ipairs({{1;91},{1;41};{42,91}})do while O[1]<O[2]do f[O[1]],f[O[2]],O[1],O[2]=f[O[2]],f[O[1]],O[1]+1,O[2]-1 end end local function m(m)return f[m+60549]end do local m=string.sub local O=string.char local p=table.insert local Q=table.concat local B=type local P=f local n={["0"]=0;["9"]=1,["5"]=2,["8"]=3;["1"]=4,F=5,A=6,["4"]=7;C=8;["7"]=9;["3"]=10,["2"]=11,D=12,E=13;B=14;["6"]=15}for f=1,#P,1 do local R=P[f]local K=R[2]if B(K)=="string"then local f={}for Q=1,#K,2 do local B=n[m(K,Q,Q)]local P=n[m(K,Q+1,Q+1)]local R=B*16+P p(f,O(R))end R[2]=Q(f)end end end 

---------------------------------------------
-- PHẦN XỬ LÝ: GOM DỮ LIỆU & COPY CLIPBOARD --
---------------------------------------------
local full_dump = "-- [DUMP KẾT QUẢ TỪ IRONBREW SCRIPT] --\n\n"
local count = 0

-- Sắp xếp lại thứ tự để dễ nhìn hơn (nếu có thể), nhưng chủ yếu là gom hết vào
for index, value in pairs(f) do
    if type(value) == "table" and value[2] then
        local content = tostring(value[2])
        -- Lọc bớt rác (các ký tự lạ) nếu cần, hoặc để nguyên
        count = count + 1
        full_dump = full_dump .. string.format("-- Line %d:\n%s\n\n", count, content)
    end
end

full_dump = full_dump .. "-- [KẾT THÚC DUMP] --"

-- In ra console để check
print("Dang xu ly " .. count .. " dong du lieu...")

-- Lệnh copy vào clipboard (Hỗ trợ hầu hết executor: Delta, Fluxus, Krnl...)
if setclipboard then
    setclipboard(full_dump)
    print("✅ ĐÃ COPY TOÀN BỘ SCRIPT (DECODED) VÀO CLIPBOARD!")
    print("👉 Hãy vào ứng dụng Ghi chú (Note) và Paste ra để xem.")
else
    -- Fallback nếu không có setclipboard
    print("❌ Executor không hỗ trợ copy. Hãy xem ở Console (F9).")
    print(full_dump)
end

-- Dừng script tại đây để không chạy phần máy ảo độc hại
do return end 

-- Phần VM phía dưới này sẽ không chạy
return(function(f,p,Q,B,P,n,R,g,L,a,k,d,E,O,U,H,K,b,M,V)
end)(...)
end)(...)
