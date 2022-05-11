using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;


[Serializable]
[SqlUserDefinedType(Format.UserDefined, MaxByteSize = 8000)]
public struct Address : INullable, IBinarySerialize
{
    string street;
    string number;
    string flat;
    public override string ToString()
    {
        return $"Street: {this.street}";
    }
    public bool IsNull
    {
        get
        {
            return _null;
        }
    }
    public static Address Null
    {
        get
        {
            Address h = new Address();
            h._null = true;
            return h;
        }
    }
    public static Address Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;
        string[] param = s.Value.Split(',');
        Address u = new Address();
        u.street = param[0];
        u.number = param[1];
        u.flat = param[2];
        return u;
    }
    public string Method1()
    {
        return string.Empty;
    }
    public static SqlString Method2()
    {
        return new SqlString("");
    }
    public void Read(BinaryReader r)
    {
        street = r.ReadString();
    }

    public void Write(BinaryWriter w)
    {
        w.Write(street.ToString() + " - " + number.ToString() + " - " + flat.ToString());
    }
    public int _var1;
    private bool _null;
}