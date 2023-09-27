<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Area extends Model
{
    use HasFactory;

    protected $fillable = [
        'users_id',
        'name',
        'description',
        'activated',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'users_id', 'id');
    }

    public function actions()
    {
        return $this->hasMany(Action::class);
    }

    public function reactions()
    {
        return $this->hasMany(Reaction::class);
    }
}