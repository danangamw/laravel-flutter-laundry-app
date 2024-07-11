<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Shop extends Model
{
    use HasFactory;

    public function laundries()
    {
        return $this->belongsTo(Laundry::class);
    }

    protected $fillable = [
        'image',
        'name',
        'location',
        'city',
        'delivery',
        'whatsapp',
        'description',
        'price',
        'rate'
    ];
}
