//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Model
{
    using System;
    using System.Collections.Generic;
    
    public partial class ProductCategoryField
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public int CategoryFieldId { get; set; }
        public string Value { get; set; }
    
        public virtual CategoryField CategoryField { get; set; }
        public virtual Product Product { get; set; }
    }
}
